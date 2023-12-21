import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';

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
    /// Controller to handle PageView and also handles initial page
    final pageController = PageController(initialPage: 0);

    /// Controller to handle bottom nav bar and also handles initial page
    final controller = NotchBottomBarController(index: 0);

    final List<Widget> pages = [
      const Home(),
      // const TimeEntries(),
      // const Transactions(),
      // const Profile(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            children: List.generate(pages.length, (index) => pages[index]),
          ),
          // const GettingStarted(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
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
    );
  }
}
