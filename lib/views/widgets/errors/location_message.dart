import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class LocationMessage extends StatefulWidget {
  const LocationMessage({super.key});

  @override
  State<LocationMessage> createState() => _LocationMessageState();
}

class _LocationMessageState extends State<LocationMessage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                      const SizedBox(height: 100),
                      const Text(
                        "Location access is important",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Image.asset(
                            'assets/images/first_login_image.jpg',
                            width: size.width * .6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "We need to access your location to accurately record your work hours and enable us to verify your presence at your designated workplace.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundedCustomButton(
                        onPressed: () {
                          Geolocator.requestPermission();
                          context.go('/login');
                        },
                        bgColor: bgPrimaryBlue,
                        label: "Continue",
                        size: Size(size.width * .60, 30),
                        fontSize: 14,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "You can change this option later in the app's  settings.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: darkGray,
                          fontSize: 12,
                        ),
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
}
