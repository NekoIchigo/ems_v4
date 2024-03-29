import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCall {
  final String _baseUrl = 'http://10.10.10.221:8000/api/mobile'; // company ip
  // final String _baseUrl = "https://stg-ems.globalland.com.ph/api";
  final Duration _timeOutDuration = const Duration(seconds: 30);
  final client = RetryClient(http.Client());

  Future postRequest(Map<String, dynamic> data, String apiUrl,
      {File? file}) async {
    var fullUrl = _baseUrl + apiUrl;
    var token = await _getToken();
    try {
      if (file != null) {
        // POST request with file
        var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = token;

        request.fields['data'] = jsonEncode(data);

        var fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
        var length = await file.length();
        var multipartFile =
            http.MultipartFile('file', fileStream, length, filename: file.path);
        request.files.add(multipartFile);

        return await request.send().timeout(
          _timeOutDuration,
          onTimeout: () {
            log('request time out');
            throw TimeoutException('Request Timeout');
          },
        );
      } else {
        // POST request without file
        return await http
            .post(Uri.parse(fullUrl),
                body: jsonEncode(data), headers: _setHeaders(token))
            .timeout(
          _timeOutDuration,
          onTimeout: () {
            log('request time out');
            return http.Response('Request Timeout', 408);
          },
        );
      }
    } finally {
      client.close();
    }
  }

  Future getRequest(String apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var token = await _getToken();
    try {
      return await http
          .get(Uri.parse(fullUrl), headers: _setHeaders(token))
          .timeout(
        _timeOutDuration,
        onTimeout: () {
          log('request time out');
          return http.Response('Request Timeout', 408);
        },
      );
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
}
