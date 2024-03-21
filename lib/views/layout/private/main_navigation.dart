import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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

class _MainNavigationState extends State<MainNavigation> {
  final MainNavigationController _mainNavigationController =
      Get.find<MainNavigationController>();
  bool isBack = false;

  Future<bool> exitDialog() async {
    return false;
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
        backgroundColor: bgPrimaryBlue,
        height: 55,
        items: _mainNavigationController.navigation,
        curveSize: 80,
        top: -15,
        style: TabStyle.reactCircle,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/in_out');
            case 1:
              context.go('/time_entries');
            case 2:
              context.go('/transaction');
            case 3:
              context.go('/notification');
            case 4:
              context.go('/profile');
          }
        },
      ),
    );
  }
}
