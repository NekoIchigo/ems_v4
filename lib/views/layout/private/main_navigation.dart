import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/constants.dart';
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

  Future<bool> exitDialog() async {
    return false;
  }

  @override
  void initState() {
    _mainNavigationController.tabController = TabController(
        vsync: this, length: _mainNavigationController.navigation.length);

    if (_authController.employee?.value.employeeDetails.employmentType
            ?.transactionAccess ==
        0) {
      _mainNavigationController.navigation.removeAt(2);
      _mainNavigationController.navigationPath.removeAt(2);
      _mainNavigationController.navigation.removeAt(3);
      _mainNavigationController.navigationPath.removeAt(3);
    }
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
      bottomNavigationBar: ConvexAppBar(
        controller: _mainNavigationController.tabController,
        backgroundColor: bgPrimaryBlue,
        height: 55,
        items: _mainNavigationController.navigation,
        curveSize: 80,
        top: -15,
        style: TabStyle.reactCircle,
        onTap: (index) {
          final String path = _mainNavigationController.navigationPath[index];
          context.go(path);
        },
      ),
    );
  }
}
