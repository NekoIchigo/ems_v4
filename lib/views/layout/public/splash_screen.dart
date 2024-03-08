import 'dart:async';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    initFunctions();
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: globalBaseUrl.contains('stg'),
            child: const Text("Stg App"),
          ),
          Center(
            child: SizedBox(
              height: queryData.size.height * 0.12,
              child: Image.asset(
                'assets/images/GEMS4blue.png',
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
