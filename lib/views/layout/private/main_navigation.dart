import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/getting_started.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/private/notification/notification_page.dart';
import 'package:ems_v4/views/layout/private/profile/profile.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries.dart';
import 'package:ems_v4/views/layout/private/transactions/transactions.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  @override
  Widget build(BuildContext context) {
    // ! https://pub.dev/packages/convex_bottom_bar Change bottom bar
    /// Controller to handle PageView and also handles initial page
    final pageController = PageController(initialPage: 0);

    /// Controller to handle bottom nav bar and also handles initial page
    // final controller = NotchBottomBarController(index: 0);

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
            repeat: false,
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
            repeat: false,
            fit: BoxFit.contain,
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
        // ColorFiltered(
        //   colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Lottie.asset(
        //       "assets/lottie/Transaction.json",
        //       repeat: false,
        //     ),
        //   ),
        // ),
        activeIcon: Icon(
          Icons.edit_document,
          color: darkGray,
        ),
        //  Padding(
        //   padding: const EdgeInsets.all(0.0),
        //   child: Lottie.asset(
        //     "assets/lottie/Transaction.json",
        //     repeat: false,
        //   ),
        // ),
      ),
      TabItem(
        icon: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn),
          child: Lottie.asset(
            "assets/lottie/Bell.json",
            repeat: false,
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
            repeat: false,
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

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(pages.length, (index) => pages[index]),
            ),
            const GettingStarted(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: bgPrimaryBlue,
          height: 55,
          items: navigations,
          curveSize: 80,
          top: -15,
          style: TabStyle.reactCircle,
          // cornerRadius: 5,
          onTap: (index) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ));
  }
}


/* 
AnimatedNotchBottomBar(
        notchBottomBarController: controller,
        color: navBlue,
        showLabel: false,
        notchColor: navBlue,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            activeItem: Padding(
              padding: const EdgeInsets.all(0),
              child: Lottie.asset("assets/lottie/Home.json",
                  repeat: false, fit: BoxFit.contain),
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
            ),
            activeItem: Lottie.asset("assets/lottie/Calendar.json",
                repeat: false, fit: BoxFit.contain),
            itemLabel: 'Logs',
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            activeItem: Padding(
              padding: const EdgeInsets.all(0),
              child: Lottie.asset("assets/lottie/Bell.json",
                  repeat: false, fit: BoxFit.contain),
            ),
            itemLabel: 'Logs',
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
            ),
            activeItem: Padding(
              padding: const EdgeInsets.all(0),
              child: Lottie.asset("assets/lottie/Account.json",
                  repeat: false, fit: BoxFit.contain),
            ),
            itemLabel: 'Logs',
          ),
        ],
        onTap: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        kIconSize: 25,
        kBottomRadius: 15,
      ),
*/