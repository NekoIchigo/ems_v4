import 'dart:async';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * .15),
                    const Text(
                      textAlign: TextAlign.center,
                      'To continue, turn on your device’s location settings:',
                      style: TextStyle(
                        color: darkGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          'assets/images/no_location_permission.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: size.width * .8,
                      child: Text(
                        extraData['type'] == 'off'
                            ? 'Enable location services'
                            : 'Enable location permission',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: darkGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    RoundedCustomButton(
                      onPressed: () {
                        if (isSettingsOpen) {
                          context.go(extraData['path']);
                        } else {
                          if (extraData['type'] == 'off') {
                            Geolocator.openLocationSettings().then((value) {
                              Timer(const Duration(seconds: 1), () {
                                setState(() {
                                  isSettingsOpen = true;
                                });
                              });
                            });
                          } else {
                            Geolocator.openAppSettings().then((value) {
                              Timer(const Duration(seconds: 1), () {
                                setState(() {
                                  isSettingsOpen = true;
                                });
                              });
                            });
                          }
                        }
                      },
                      bgColor: bgPrimaryBlue,
                      label: isSettingsOpen
                          ? 'Try Again'
                          : 'Update location settings',
                      size: Size(size.width * .55, 30),
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
