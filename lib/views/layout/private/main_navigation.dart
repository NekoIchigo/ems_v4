import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/notification_controller.dart';
import 'package:ems_v4/views/layout/private/getting_started.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

GlobalKey mainNavigationKey = GlobalKey();

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final MainNavigationController _mainNavigationController =
      Get.find<MainNavigationController>();
  bool isBack = false;
  final NotificationController _notificationController =
      NotificationController();

  Future<bool> exitDialog() async {
    return false;
  }

  @override
  void initState() {
    String? transactionAccess = _authController
        .employee!.value.employeeDetails.employmentType!.transactionAccess;

    if (transactionAccess == '0' || transactionAccess == '1') {
      _mainNavigationController.transactionAccess["value"] =
          transactionAccess == '0';
      transactionAccess = null;
    }

    if (transactionAccess != null) {
      final data = jsonDecode(transactionAccess);

      _mainNavigationController.transactionAccess['value'] =
          data['value'] ?? false;
      _mainNavigationController.transactionAccess['leave'] =
          data['leave'] ?? false;
      _mainNavigationController.transactionAccess['overtime'] =
          data['overtime'] ?? false;
      _mainNavigationController.transactionAccess['change_restday'] =
          data['change_restday'] ?? false;
      _mainNavigationController.transactionAccess['dtr_correction'] =
          data['dtr_correction'] ?? false;
      _mainNavigationController.transactionAccess['change_schedule'] =
          data['change_schedule'] ?? false;
      _mainNavigationController.transactionAccess['time_records'] =
          data['time_records'] ?? false;
      _mainNavigationController.transactionAccess['add_schedule'] =
          data['add_schedule'] ?? false;
    }

    _mainNavigationController.tabController = TabController(
        vsync: this, length: _mainNavigationController.navigation.length);

    if (!_mainNavigationController.transactionAccess["value"] &&
        _mainNavigationController.navigation.length >= 4) {
      _mainNavigationController.navigation.removeAt(2);
      _mainNavigationController.navigationPath.removeAt(2);
      _mainNavigationController.navigation.removeAt(2);
      _mainNavigationController.navigationPath.removeAt(2);
    }
    _notificationController.index();

    super.initState();
  }

  @override
  void dispose() {
    _mainNavigationController.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainNavigationKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          EMSContainer(child: widget.child),
          const GettingStarted(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: ConvexAppBar.badge(
        {
          3: Obx(() => Visibility(
                visible: _notificationController.showNotificationBadge.isTrue,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ))
        },
        controller: _mainNavigationController.tabController,
        backgroundColor: bgPrimaryBlue,
        height: 55,
        items: _mainNavigationController.navigation,
        curveSize: 80,
        top: -15,
        style: TabStyle.reactCircle,
        onTap: (index) {
          final String path = _mainNavigationController.navigationPath[index];
          if (index == 3) {
            _notificationController.showNotificationBadge.value = false;
          }
          context.go(path);
        },
      ),
    );
  }
}
