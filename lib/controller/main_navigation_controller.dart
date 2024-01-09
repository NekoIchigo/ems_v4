import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/private/notification/notification_page.dart';
import 'package:ems_v4/views/layout/private/profile/profile.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries.dart';
import 'package:ems_v4/views/layout/private/transactions/transactions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MainNavigationController extends GetxController {
  RxInt pageIndex = 0.obs;
  final int routerKey = 0;
  final List<Widget> pages = [
    const Home(),
    const TimeEntries(),
    const Transactions(),
    const NotificationPage(),
    const Profile(),
  ];

  final List<TabItem> navigations = [
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
          colorFilter: const ColorFilter.mode(darkGray, BlendMode.srcIn),
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
          colorFilter: const ColorFilter.mode(darkGray, BlendMode.srcIn),
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
        color: darkGray,
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
          colorFilter: const ColorFilter.mode(darkGray, BlendMode.srcIn),
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
          colorFilter: const ColorFilter.mode(darkGray, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Account.json",
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  ];
}
