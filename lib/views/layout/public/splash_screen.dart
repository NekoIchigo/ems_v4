import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    initFunctions();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      log(result.toString());
    });
  }

  Future initFunctions() async {
    _settings.isSettingsOpen.value = false;
    await _settings.getServerTime();
    _settings.updateTimeToRealTime();
    await _settings.checkAppVersionMaintenance();
    await _settings.checkLocationPermission('/');

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
          // Visibility(
          //   visible: globalBaseUrl.contains('stg'),
          //   child: const Text("Stg App"),
          // ),
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
