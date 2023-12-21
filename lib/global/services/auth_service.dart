import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/company.dart';
import 'package:ems_v4/models/employee.dart';
import 'package:ems_v4/models/user.dart';
import 'package:ems_v4/views/widgets/dialog/ems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  // static AuthService get instance => Get.find();
  late SharedPreferences localStorage;
  final ApiCall apiCall = ApiCall();

  RxBool isLoading = false.obs;
  RxBool autheticated = false.obs;
  String? token;
  late Rx<User> user;
  late Rx<Company> company;
  late Rx<Employee> employee;

  Future<AuthService> init() async {
    localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    if (token != null) {
      var response = await apiCall.getRequest('/check-token');
      var result = jsonDecode(response.body);
      if (!result['token']) {
        Get.toNamed('/login');
      } else {
        setAuthStatus();
      }
    }
    autheticated.value = token != null;
    return this;
  }

  Future<void> setAuthStatus() async {
    String? userData = localStorage.getString('user');
    if (userData != null) {
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      user = User(
        id: data['id'],
        email: data['email'],
        employeeNumber: data['employee_number'],
      ).obs;
      company = Company(id: companyData['id'], name: companyData['name']).obs;
      employee = Employee(
        id: employeeData['id'],
        employeeNumber: employeeData['employee_details']['employee_number'],
        firstName: employeeData['first_name'],
        middleName: employeeData['middle_name'] ?? '',
        lastName: employeeData['last_name'],
        birthday: employeeData['birthday'],
        gender: employeeData['gender'],
        civilStatus: employeeData['civil_status'],
      ).obs;
    }
  }

  Future login(String email, String password, BuildContext context) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest(
        {
          'email': email,
          'password': password,
        },
        '/mobile/login',
      );

      var result = jsonDecode(response.body);

      if (result['success']) {
        autheticated.value = result['success'];

        var data = result['data'];
        var employeeData = data['employee'];
        var companyData = employeeData['company'];

        localStorage.setString('token', result['token']);
        localStorage.setString('user', jsonEncode(result['data']));

        user = User(
          id: data['id'],
          email: data['email'],
          employeeNumber: data['employee_number'],
        ).obs;
        company = Company(id: companyData['id'], name: companyData['name']).obs;
        employee = Employee(
          id: employeeData['id'],
          employeeNumber: employeeData['employee_details']['employee_number'],
          firstName: employeeData['first_name'],
          middleName: employeeData['middle_name'] ?? '',
          lastName: employeeData['last_name'],
          birthday: employeeData['birthday'],
          gender: employeeData['gender'],
          civilStatus: employeeData['civil_status'],
        ).obs;
        Get.toNamed('/home');
      } else {
        await EMSDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Invalid username or password.",
          type: "error",
          buttonNumber: 0,
        ).show(context);
      }
      isLoading.value = false;
    } catch (error) {
      await EMSDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ).show(context);
      isLoading.value = false;
      printError(info: 'Error Message Login: $error');
    }
  }

  Future logout(BuildContext context) async {
    try {
      apiCall.postRequest({}, '/mobile/logout').then((value) {
        localStorage.clear();
        Get.toNamed('/login');
      });
    } catch (error) {
      await EMSDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ).show(context);
      isLoading.value = false;
      printError(info: 'Error Message: $error');
    }
  }
}
