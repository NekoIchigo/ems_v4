import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCall {
  // final String _baseUrl = 'http://192.168.0.25:8000/api/mobile';
  // final String _baseUrl = 'http://10.10.10.42:8000/api/mobile'; // company ip

  final String _baseUrl = "${globalBaseUrl}api";
  // final Duration _timeOutDuration = const Duration(seconds: 30);
  final client = RetryClient(http.Client());

  Future postRequest({
    Map<String, dynamic>? data,
    required String apiUrl,
    List<File>? files,
    Function? catchError,
    bool showErrorDialog = true,
    String? path,
  }) async {
    var fullUrl = _baseUrl + apiUrl;
    var token = await _getToken();
    try {
      if (files != null) {
        // POST request with file
        var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = token;

        request.fields['data'] = jsonEncode(data);
        for (var file in files) {
          request.files.add(
            http.MultipartFile(
              'files[]',
              http.ByteStream(Stream.castFrom(file.openRead())),
              await file.length(),
              filename: file.path,
            ),
          );
        }

        final response = await request.send();

        return response;
      } else {
        final response = await http.post(Uri.parse(fullUrl),
            body: jsonEncode(data), headers: _setHeaders(token));
        var body = jsonDecode(response.body);

        if (body.containsKey('message') &&
            body['message']
                .toString()
                .toLowerCase()
                .contains('unauthenticated')) {
          navigatorKey.currentContext!.go('/');
        }
        return body;
      }
    } catch (error) {
      if (error is http.ClientException) {
        String currentPath = path ??
            GoRouter.of(navigatorKey.currentContext!)
                .routeInformationProvider
                .value
                .uri
                .toString();

        Timer(const Duration(seconds: 1), () {
          navigatorKey.currentContext!.go('/no-internet', extra: currentPath);
        });
      } else if (showErrorDialog) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "Oops",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: error.toString().contains('html')
                  ? "Unable to connect to the server."
                  : "Error: ${error.toString()}",
              type: "error",
              buttonNumber: 0,
            );
          },
        );
      }
      if (catchError != null) catchError(error);
    } finally {
      client.close();
    }
  }

  Future getRequest({
    required String apiUrl,
    Map<String, dynamic>? parameters,
    Function? catchError,
    bool showErrorDialog = true,
    String? path,
  }) async {
    var fullUrl = _baseUrl + apiUrl;
    var token = await _getToken();
    try {
      final response = await http.get(Uri.parse(_buildUrl(fullUrl, parameters)),
          headers: _setHeaders(token));
      //     .timeout(
      //   _timeOutDuration,
      //   onTimeout: () {
      //     log('request time out');
      //     return http.Response('Request Timeout', 408);
      //   },
      // )
      var body = jsonDecode(response.body);
      if (body.containsKey('message') &&
          body['message']
              .toString()
              .toLowerCase()
              .contains('unauthenticated')) {
        navigatorKey.currentContext!.go('/');
      }
      return body;
    } catch (error) {
      if (error is http.ClientException) {
        String currentPath = path ??
            GoRouter.of(navigatorKey.currentContext!)
                .routeInformationProvider
                .value
                .uri
                .toString();
        Timer(const Duration(seconds: 1), () {
          navigatorKey.currentContext!.go('/no-internet', extra: currentPath);
        });
      } else if (showErrorDialog) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "Oops",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: error.toString().contains('html')
                  ? "Unable to connect to the server."
                  : "Error: ${error.toString()}",
              type: "error",
              buttonNumber: 0,
            );
          },
        );
      }
      if (catchError != null) catchError(error);
    } finally {
      client.close();
    }
  }

  Future _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }

  Map<String, String> _setHeaders(var token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  String _buildUrl(String url, Map<String, dynamic>? parameters) {
    if (parameters == null || parameters.isEmpty) {
      return url;
    }
    var queryString =
        parameters.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$url?$queryString';
  }
}
