import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/company.dart';
import 'package:ems_v4/models/employee.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  late SharedPreferences _localStorage;
  final ApiCall apiCall = ApiCall();

  RxBool isLoading = false.obs;
  RxBool autheticated = false.obs;
  String? token;
  late Rx<Company> company;
  late Rx<Employee> employee;

  Future<AuthService> init() async {
    _localStorage = await SharedPreferences.getInstance();
    token = _localStorage.getString('token');
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
    String? userData = _localStorage.getString('user');
    if (userData != null) {
      var data = jsonDecode(userData);
      var employeeData = data['employee'];
      var companyData = employeeData['company'];

      employee = Employee.fromJson(employeeData).obs;
      company = Company.fromJson(companyData).obs;
    }
  }

  Future login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await apiCall
          .postRequest({'email': email, 'password': password}, '/login');
      final result = jsonDecode(response.body);

      if (result['success']) {
        autheticated.value = result['success'];

        var userData = result['data'];
        var employeeData = userData['employee'];
        var companyData = employeeData['company'];

        employee = Employee.fromJson(employeeData).obs;
        company = Company.fromJson(companyData).obs;

        _localStorage.setString('token', result['token']);
        _localStorage.setString('user', jsonEncode(result['data']));

        Get.offNamed('/');
      } else {
        Get.dialog(const GetDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Invalid username or password.",
          type: "error",
          buttonNumber: 0,
        ));
      }
      isLoading.value = false;
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ));
      isLoading.value = false;
      printError(info: 'Error Message Login: $error');
    }
  }

  Future logout() async {
    try {
      apiCall.postRequest({}, '/logout').then((value) {
        _localStorage.clear();
        Get.toNamed('/login');
      });
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
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
