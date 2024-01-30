import 'dart:convert';

import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/controller/location_controller.dart';
import 'package:ems_v4/controller/main_navigation_controller.dart';
import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/controller/transaction_controller.dart';
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
  String userEmail = '';

  RxBool isLoading = false.obs;
  RxBool autheticated = false.obs;
  String? token;
  late Rx<Company> company;
  late Rx<Employee> employee;

  Future<AuthService> init() async {
    _localStorage = await SharedPreferences.getInstance();
    auth = LocalAuthentication();

    if (_localStorage.getBool('auth_biometrics') ?? false) {
      auth.isDeviceSupported().then(
          (bool isDeviceSupported) => isSupported.value = isDeviceSupported);
      List<BiometricType> availableBiomentrics =
          await auth.getAvailableBiometrics();
      print(availableBiomentrics);
      setLocalAuth();
    }

    token = _localStorage.getString('token');
    if (token != null) {
      var response = await apiCall.getRequest('/check-token');
      var result = jsonDecode(response.body);
      autheticated.value = result['token'];

      if (!result['token']) {
        Get.toNamed('/login');
      } else {
        setAuthStatus();
      }
    }
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

  Future<void> setLocalAuth() async {
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
        (bool isDeviceSupported) => isSupported.value = isDeviceSupported);
    List<BiometricType> availableBiomentrics =
        await auth.getAvailableBiometrics();
    print(availableBiomentrics);
  }

  Future login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await apiCall
          .postRequest({'email': email, 'password': password}, '/login');
      final result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        userEmail = email;
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
          Get.offNamed('/create_password');
        } else {
          Get.offNamed('/');
        }
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: result['message'],
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
      isLoading.value = false;
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error login: $error",
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
        // _localStorage.remove('token');
        Get.delete<HomeController>();
        Get.delete<TimeEntriesController>();
        Get.delete<LocationController>();
        Get.delete<MainNavigationController>();
        Get.delete<TransactionController>();
        Get.delete<CreatePasswordController>();

        Get.put(HomeController());
        Get.put(TimeEntriesController());
        Get.put(LocationController());
        Get.put(MainNavigationController());
        Get.put(TransactionController());
        Get.put(CreatePasswordController());

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
