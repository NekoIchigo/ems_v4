import 'dart:convert';
import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/models/company.dart';
import 'package:ems_v4/models/employee.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AuthController extends GetxController {
  late SharedPreferences _localStorage;
  final SettingsController _settings = Get.find<SettingsController>();
  final LocalAuthentication auth = LocalAuthentication();
  final ApiCall apiCall = ApiCall();
  String? userEmail;

  RxBool isLoading = false.obs,
      authenticated = false.obs,
      isBioEnabled = false.obs,
      hasUser = false.obs,
      isMaintenance = false.obs,
      isSupported = false.obs;
  RxString pinError = ''.obs;
  String? token;
  late Rx<Company> company;
  Rx<Employee>? employee;

  Future<void> initAuth() async {
    _localStorage = await SharedPreferences.getInstance();
    token = _localStorage.getString('token');
    setLocalAuth();
    if (token != null) {
      var result = await apiCall.getRequest(
        apiUrl: '/mobile/check-token',
        catchError: (error) {},
      );
      if (!result.containsKey('token')) {
        authenticated.value = false;
        isBioEnabled.value = false;
      } else {
        setAuthStatus();
      }
    }
  }

  Future<void> setAuthStatus() async {
    _localStorage = await SharedPreferences.getInstance();
    String? userData = _localStorage.getString('user');
    if (userData != null) {
      hasUser.value = true;
      authenticated.value = true;
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;
    }
  }

  Future<void> setLocalAuth() async {
    _localStorage = await SharedPreferences.getInstance();
    bool? bio = _localStorage.getBool('auth_biometrics');
    String? userData = _localStorage.getString('user');
    if (userData != null) {
      hasUser.value = true;
      auth.isDeviceSupported().then(
          (bool isDeviceSupported) => isSupported.value = isDeviceSupported);
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty && isSupported.isTrue) {
        isBioEnabled.value = bio ?? false;
      }
    }
  }

  Future<String?> isEmailSaved() async {
    _localStorage = await SharedPreferences.getInstance();
    String? userData = _localStorage.getString('user');

    if (userData != null) {
      authenticated.value = true;
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;
      return employee!.value.employeeContact.email;
    }
    return null;
  }

  Future login(String email, String password, String code) async {
    await _settings.checkAppVersionMaintenance();
    if (_settings.isMaintenance.isTrue) {
      return;
    }
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;

    final data = {
      'email': email,
      'password': password,
      'code': code.toUpperCase()
    };

    final result = await apiCall.postRequest(
      apiUrl: '/mobile/login',
      data: data,
      catchError: (error) {
        isLoading.value = false;
      },
    );
    if (result.containsKey('success') && result['success']) {
      authenticated.value = result['success'];

      var userData = result['data'];
      _localStorage.setString('user', jsonEncode(userData));
      var employeeData = userData['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;

      _localStorage.setString('token', result['token']);
      _localStorage.setString('user', jsonEncode(result['data']));
      if (result.containsKey('is_first_login') && result['is_first_login']) {
        navigatorKey.currentContext?.go('/create_password');
      } else {
        navigatorKey.currentContext?.go('/in_out');
      }
    } else {
      if (result.containsKey('deactivate') && result['deactivate'] == 1) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "",
              hasMessage: true,
              hasLottie: false,
              withCloseButton: true,
              hasCustomWidget: true,
              customWidget: Column(
                children: [
                  Image.asset('assets/images/no_data.png', width: 400),
                ],
              ),
              message: result['errors']['email'][0],
              type: "error",
              buttonNumber: 0,
            );
          },
        );
        return null;
      }
      isLoading.value = false;
      return result;
    }
    isLoading.value = false;
  }

  Future pinAuth(String password) async {
    await _settings.checkAppVersionMaintenance();
    if (_settings.isMaintenance.isTrue) {
      return;
    }
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;

    String? email = await isEmailSaved();

    if (email != null) {
      final Map<String, String> data = {'email': email, 'pin': password};
      final result = await apiCall.postRequest(
        apiUrl: '/mobile/pin-auth',
        data: data,
        catchError: (error) {
          isLoading.value = false;
        },
      );
      if (result.containsKey('success') && result['success']) {
        authenticated.value = result['success'];

        var userData = result['data'];
        _localStorage.setString('user', jsonEncode(userData));
        var employeeData = userData['employee'];
        var companyData = employeeData['company'];

        employee = Employee.fromJson(employeeData).obs;
        company = Company.fromJson(companyData).obs;

        _localStorage.setString('token', result['token']);
        _localStorage.setString('user', jsonEncode(result['data']));
        if (result.containsKey('is_first_login') && result['is_first_login']) {
          navigatorKey.currentContext?.go('/create_password');
        } else {
          navigatorKey.currentContext?.go('/in_out');
        }
      } else {
        if (result.containsKey('deactivate') && result['deactivate']) {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return GemsDialog(
                  title: "Oops",
                  hasMessage: true,
                  withCloseButton: true,
                  hasCustomWidget: true,
                  customWidget:
                      Image.asset('assets/images/no_data.png', width: 400),
                  message:
                      "Your account has been deactivated. You will not be able to login.",
                  type: "error",
                  buttonNumber: 0,
                );
              });
          return null;
        }
        isLoading.value = false;
        return result['message'];
      }
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Something went wrong! Login by password.",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }

    isLoading.value = false;
  }

  Future<void> localAuthenticate() async {
    await _settings.checkAppVersionMaintenance();
    if (_settings.isMaintenance.isTrue) {
      return;
    }
    _localStorage = await SharedPreferences.getInstance();
    await setLocalAuth();
    if (isBioEnabled.isTrue) {
      try {
        bool localAuthenticated = await auth.authenticate(
            localizedReason: "Authenticate to Login in the system.",
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ));
        if (localAuthenticated) {
          authenticated.value = localAuthenticated;
          setAuthStatus();
          navigatorKey.currentContext?.go('/in_out');
        }
      } on PlatformException catch (e) {
        log(e.toString());
      }
    }
  }

  Future logout() async {
    isLoading.value = true;

    await apiCall
        .postRequest(
            apiUrl: '/mobile/logout',
            catchError: (error) => isLoading.value = false)
        .then((value) {
      setAuthStatus();
      setLocalAuth();
      navigatorKey.currentContext?.go('/login');
    });

    isLoading.value = false;
  }
}
