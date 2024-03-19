import 'dart:convert';
import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/company.dart';
import 'package:ems_v4/models/employee.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  late SharedPreferences _localStorage;
  late final LocalAuthentication auth;
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
    auth = LocalAuthentication();
    token = _localStorage.getString('token');
    setLocalAuth();
    if (token != null) {
      var response = await apiCall.getRequest('/check-token');
      var result = jsonDecode(response.body);
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
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;
    try {
      final response = await apiCall.postRequest(
          {'email': email, 'password': password, 'code': code.toUpperCase()},
          '/login');
      final result = jsonDecode(response.body);
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
          Get.offAllNamed('/create_password');
        } else {
          Get.offAllNamed('/');
        }
      } else {
        if (result.containsKey('deactivate') && result['deactivate'] == 1) {
          Get.dialog(
            GemsDialog(
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
              message:
                  "Your account has been deactivated.\n You will not be able to login.",
              type: "error",
              buttonNumber: 0,
            ),
          );
          return null;
        }
        return result;
      }

      isLoading.value = false;
    } catch (error) {
      Get.dialog(GemsDialog(
        title: "Oops",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error login: $error",
        type: "error",
        buttonNumber: 0,
      ));
      isLoading.value = false;
      printError(info: 'Error Message Login: $error');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future pinAuth(String password) async {
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;

    try {
      String? email = await isEmailSaved();

      if (email != null) {
        final response = await apiCall
            .postRequest({'email': email, 'pin': password}, '/pin-auth');
        final result = jsonDecode(response.body);

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
          if (result.containsKey('is_first_login') &&
              result['is_first_login']) {
            Get.offAllNamed('/create_password');
          } else {
            Get.offAllNamed('/');
          }
        } else {
          if (result.containsKey('deactivate') && result['deactivate']) {
            Get.dialog(
              GemsDialog(
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
              ),
            );
            return null;
          }
          return result['message'];
        }
      } else {
        Get.dialog(
          const GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Something went wrong! Login by password.",
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
    } catch (error) {
      await Get.dialog(
        const GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Something went wrong! Login by password.",
          type: "error",
          buttonNumber: 0,
        ),
      );
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> localAuthenticate() async {
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
          Get.offAllNamed('/');
        }
      } on PlatformException catch (e) {
        log(e.toString());
      }
    }
  }

  Future logout() async {
    try {
      apiCall.postRequest({}, '/logout').then((value) {
        setAuthStatus();
        setLocalAuth();
        Get.offAllNamed('/login');
      });
    } catch (error) {
      Get.dialog(GemsDialog(
        title: "Oops",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ));
      isLoading.value = false;
      printError(info: 'Error Message: $error');
    }
  }
}
