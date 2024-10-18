import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MainNavigationController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  late TabController tabController;
  RxMap<String, dynamic> transactionAccess = {
    'value': true,
    'leave': true,
    'overtime': true,
    'change_restday': true,
    'dtr_correction': true,
    'change_schedule': true,
    'time_records': true,
    'add_schedule': true,
  }.obs;

  RxList<TabItem> navigation = [
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Home.json",
          animate: false,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Home.json",
            repeat: false,
          ),
        ),
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Calendar.json",
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Calendar.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    const TabItem(
      icon: Icons.edit_document,
      activeIcon: Icon(
        Icons.edit_document,
        color: bgPrimaryBlue,
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Bell.json",
          animate: false,
          fit: BoxFit.contain,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Bell.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Account.json",
          animate: false,
          fit: BoxFit.contain,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Account.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  ].obs;

  final List<TabItem> defaultNavigation = [
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Home.json",
          animate: false,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Home.json",
            repeat: false,
          ),
        ),
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Calendar.json",
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Calendar.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    const TabItem(
      icon: Icons.edit_document,
      activeIcon: Icon(
        Icons.edit_document,
        color: bgPrimaryBlue,
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Bell.json",
          animate: false,
          fit: BoxFit.contain,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Bell.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
    TabItem(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        child: Lottie.asset(
          "assets/lottie/Account.json",
          animate: false,
          fit: BoxFit.contain,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(bgPrimaryBlue, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Account.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  ];

  RxList navigationPath = [
    "/in_out",
    "/time_entries",
    "/transaction",
    "/notification",
    "/profile"
  ].obs;

  final List defaultNavPath = [
    "/in_out",
    "/time_entries",
    "/transaction",
    "/notification",
    "/profile"
  ];

  void checkTransactionAccess() {
    String? transaction = _authController
        .employee!.value.employeeDetails.employmentType!.transactionAccess;

    if (transaction == '0' || transaction == '1') {
      navigation = defaultNavigation.obs;
      navigationPath = defaultNavPath.obs;
      transactionAccess["value"] = transaction == '0';
      transaction = null;
    }

    if (transaction != null) {
      final data = jsonDecode(transaction);

      navigation = defaultNavigation.obs;
      navigationPath = defaultNavPath.obs;

      transactionAccess['value'] = data['value'] ?? false;
      transactionAccess['leave'] = data['leave'] ?? false;
      transactionAccess['overtime'] = data['overtime'] ?? false;
      transactionAccess['change_restday'] = data['change_restday'] ?? false;
      transactionAccess['dtr_correction'] = data['dtr_correction'] ?? false;
      transactionAccess['change_schedule'] = data['change_schedule'] ?? false;
      transactionAccess['time_records'] = data['time_records'] ?? true;
      transactionAccess['add_schedule'] = data['add_schedule'] ?? false;
    }

    if (!transactionAccess["value"] && navigation.length >= 4) {
      navigation.removeAt(2);
      navigationPath.removeAt(2);
      navigation.removeAt(2);
      navigationPath.removeAt(2);
    }
  }
}
