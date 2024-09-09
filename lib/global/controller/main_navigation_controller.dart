import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MainNavigationController extends GetxController {
  late TabController tabController;
  final RxList<TabItem> navigation = [
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

  final RxList navigationPath = [
    "/in_out",
    "/time_entries",
    "/transaction",
    "/notification",
    "/profile"
  ].obs;
}
