import 'dart:async';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authService = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initFunctions();
    // isLoading = true;
    // // Simulating some async work
    // Timer(Duration(seconds: 3), () {
    //   // Set isLoading to false when your data is loaded or other conditions are met
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Get.offAllNamed('/login');
    //   // Navigate to the next page here
    //   // For example, Navigator.pushReplacementNamed(context, '/home');
    // });
  }

  Future initFunctions() async {
    await _settings.getServerTime();
    await _settings.checkAppVersionMaintenance();
    await _authService.initAuth();
    Timer(const Duration(seconds: 3), () {
      _authService.hasUser.isTrue
          ? Get.offAllNamed('/pin_login')
          : Get.offAllNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: Get.height * 0.15,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Image.asset(
                  'assets/images/GEMS4blue.png',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          LoadingAnimationWidget.prograssiveDots(color: primaryBlue, size: 30),
        ],
      ),
    );
  }
}
