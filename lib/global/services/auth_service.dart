import 'dart:convert';

import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/controller/location_controller.dart';
import 'package:ems_v4/controller/main_navigation_controller.dart';
import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/controller/transaction_controller.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password_container.dart';
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

  RxBool isLoading = false.obs;
  RxBool autheticated = false.obs;
  String? token;
  late Rx<Company> company;
  late Rx<Employee> employee;

  Future<AuthService> init() async {
    _localStorage = await SharedPreferences.getInstance();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
        (bool isDeviceSupported) => isSupported.value = isDeviceSupported);

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

        Get.to(() => const CreatePasswordContainer());
        // Get.offNamed('/');
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
        Get.delete<HomeController>();
        Get.delete<TimeEntriesController>();
        Get.delete<LocationController>();
        Get.delete<MainNavigationController>();
        Get.delete<TransactionController>();

        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => TimeEntriesController());
        Get.lazyPut(() => LocationController());
        Get.lazyPut(() => MainNavigationController());
        Get.lazyPut(() => TransactionController());

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
