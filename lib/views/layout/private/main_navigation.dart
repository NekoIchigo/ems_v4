import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/getting_started.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final MainNavigationController _mainNavigationController =
      MainNavigationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const GettingStarted(),
            Navigator(
              key: Get.nestedKey(0),
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  page: () => Obx(
                    () => _mainNavigationController
                        .pages[_mainNavigationController.selectedIndex.value],
                  ),
                );
              },
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: bgPrimaryBlue,
          height: 55,
          items: _mainNavigationController.navigations,
          curveSize: 80,
          top: -15,
          style: TabStyle.reactCircle,
          onTap: (index) {
            _mainNavigationController.selectedIndex.value = index;
          },
        ));
  }
}
