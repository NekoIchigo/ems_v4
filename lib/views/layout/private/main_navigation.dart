import 'package:auto_route/auto_route.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/getting_started.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

@RoutePage(name: "MainRouterPage")
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool? shouldPop = await showExitConfirmationDialog(context);
        if (shouldPop ?? false) {
          if (mounted) Navigator.of(context).pop();
        }
      },
      child: AutoTabsRouter(
          routes: const [],
          transitionBuilder: (context, child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
          builder: (context, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              body: child,
              // Stack(
              //   children: [
              //     const GettingStarted(),
              //     Navigator(
              //       key: Get.nestedKey(_mainNavigationController.routerKey),
              //       onGenerateRoute: (settings) {
              //         return GetPageRoute(
              //           page: () => Obx(
              //             () => _mainNavigationController
              //                 .pages[_mainNavigationController.selectedIndex.value],
              //           ),
              //           curve: Curves.easeInOut,
              //         );
              //       },
              //     ),
              //   ],
              // ),
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
              ),
            );
          }),
    );
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // User doesn't want to exit
              child: Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // User wants to exit
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
