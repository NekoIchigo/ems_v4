import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/company.dart';
import 'package:ems_v4/models/employee.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  late SharedPreferences _localStorage;
  late final LocalAuthentication auth;
  final ApiCall apiCall = ApiCall();
  RxBool isSupported = false.obs;
  String? userEmail;

  RxBool isLoading = false.obs;
  RxBool autheticated = false.obs;
  RxBool isBioEnabled = false.obs;
  RxBool hasUser = false.obs;
  RxString pinError = ''.obs;
  String? token;
  late Rx<Company> company;
  late Rx<Employee> employee;

  Future<AuthService> init() async {
    _localStorage = await SharedPreferences.getInstance();
    auth = LocalAuthentication();
    token = _localStorage.getString('token');
    setLocalAuth();
    if (token != null) {
      var response = await apiCall.getRequest('/check-token');
      var result = jsonDecode(response.body);
      if (!result.containsKey('token')) {
        autheticated.value = false;
        isBioEnabled.value = false;
      } else {
        setAuthStatus();
      }
    }
    return this;
  }

  Future<void> setAuthStatus() async {
    String? userData = _localStorage.getString('user');
    if (userData != null) {
      hasUser.value = true;
      autheticated.value = true;
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;
    }
  }

  Future<void> setLocalAuth() async {
    bool? bio = _localStorage.getBool('auth_biometrics');
    String? userData = _localStorage.getString('user');
    if (userData != null) {
      auth.isDeviceSupported().then(
          (bool isDeviceSupported) => isSupported.value = isDeviceSupported);
      List<BiometricType> availableBiomentrics =
          await auth.getAvailableBiometrics();
      if (availableBiomentrics.isNotEmpty) {
        isBioEnabled.value = bio ?? false;
      }
    }
  }

  Future<String?> isEmailSaved() async {
    String? userData = _localStorage.getString('user');

    if (userData != null) {
      autheticated.value = true;
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;
      return employee.value.employeeContact.email;
    }
    return null;
  }

  Future login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await apiCall
          .postRequest({'email': email, 'password': password}, '/login');
      final result = jsonDecode(response.body);

      if (result.containsKey('success') && result['success']) {
        autheticated.value = result['success'];

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
        return result;
      }

      isLoading.value = false;
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Oopps",
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
    isLoading.value = true;

    try {
      String? email = await isEmailSaved();

      if (email != null) {
        final response = await apiCall
            .postRequest({'email': email, 'pin': password}, '/pin-auth');
        final result = jsonDecode(response.body);

        if (result.containsKey('success') && result['success']) {
          autheticated.value = result['success'];

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
          // Get.dialog(
          //   GetDialog(
          //     title: "Oopps",
          //     hasMessage: true,
          //     withCloseButton: true,
          //     hasCustomWidget: false,
          //     message: "Error pin: ${result['message']}",
          //     type: "error",
          //     buttonNumber: 0,
          //   ),
          // );
          if (result.containsKey('deactive') && result['deactive']) {
            Get.dialog(
              GetDialog(
                title: "Oopps",
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
          const GetDialog(
            title: "Oopps",
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
        const GetDialog(
          title: "Oopps",
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

  Future<void> localAutheticate() async {
    if (isBioEnabled.isTrue) {
      try {
        bool localAutheticated = await auth.authenticate(
            localizedReason: "Autheticate to Login in the system.",
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ));
        if (localAutheticated) {
          autheticated.value = localAutheticated;
          setAuthStatus();
          Get.offAllNamed('/');
        }
      } on PlatformException catch (e) {
        printError(info: e.toString());
      }
    }
  }

  Future logout() async {
    try {
      apiCall.postRequest({}, '/logout').then((value) {
        setLocalAuth();
        init();
        Get.offAllNamed('/login');
      });
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Oopps",
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
