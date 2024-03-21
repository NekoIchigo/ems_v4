import 'dart:async';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authService = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    initFunctions();
  }

  Future initFunctions() async {
    await _settings.getServerTime();
    _settings.updateTimeToRealTime();
    await _settings.checkAppVersionMaintenance();
    await _settings.checkLocationPermission();

    await _authService.initAuth();
    Timer(const Duration(seconds: 3), () {
      if (_settings.isMaintenance.isFalse) {
        _authService.hasUser.isTrue
            ? _key.currentContext?.go('/pin_login')
            : _key.currentContext?.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: globalBaseUrl.contains('stg'),
            child: const Text("Stg App"),
          ),
          Center(
            child: SizedBox(
              height: size.height * 0.12,
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
