import 'dart:async';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class NoLocationPermission extends StatefulWidget {
  const NoLocationPermission({super.key});

  @override
  State<NoLocationPermission> createState() => _NoLocationPermissionState();
}

class _NoLocationPermissionState extends State<NoLocationPermission> {
  bool isSettingsOpen = false;

  @override
  void initState() {
    super.initState();
    isSettingsOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map<String, dynamic> extraData =
        GoRouterState.of(context).extra! as Map<String, dynamic>;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Positioned(
                  width: size.width,
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/login_bg_image.jpg',
                    opacity: const AlwaysStoppedAnimation(0.5),
                  ),
                ),
                Container(
                  height: size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        textAlign: TextAlign.center,
                        "GEMS wouldn't work without knowing your \nprecise location.",
                        style: TextStyle(
                          color: darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Image.asset(
                            'assets/images/no_location_permission.png',
                            width: size.width * .8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * .8,
                        child: Text(
                          extraData['type'] == 'off'
                              ? 'Enable location services'
                              : 'GEMS needs your precise location to accurately record your location each time you clock in and out.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: darkGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      RoundedCustomButton(
                        onPressed: () async {
                          if (isSettingsOpen) {
                            context.go(extraData['path']);
                          } else {
                            openLocationSettings(extraData);
                          }
                        },
                        bgColor: bgPrimaryBlue,
                        label: isSettingsOpen
                            ? 'Try Again'
                            : extraData['type'] == 'off'
                                ? 'Enable GPS location'
                                : 'Enable location permission',
                        size: Size(size.width * .60, 30),
                        fontSize: 14,
                      ),
                      RoundedCustomButton(
                        onPressed: () {
                          if (extraData['path'] != '/') {
                            context.go(extraData['path']);
                          } else {
                            context.go('/login');
                          }
                        },
                        label: "Not now",
                        bgColor: gray,
                        size: Size(size.width * .60, 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openLocationSettings(extraData) async {
    if (extraData['type'] == 'off') {
      Geolocator.openLocationSettings().then((value) {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            isSettingsOpen = true;
          });
        });
      });
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        Geolocator.openAppSettings();
      }
    }
    Timer(const Duration(seconds: 1), () {
      setState(() {
        isSettingsOpen = true;
      });
    });
  }
}
