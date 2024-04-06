import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

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
                        'Under Maintenance',
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
                            'assets/images/under-maintenance.png',
                            width: size.width * .8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: size.width * .8,
                        child: const Text(
                          "The page you're looking for is currently under maintenance and will be back soon.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: darkGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      RoundedCustomButton(
                        onPressed: () {
                          context.go('/');
                        },
                        bgColor: bgPrimaryBlue,
                        label: 'Try Again',
                        size: Size(size.width * .60, 30),
                        fontSize: 14,
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
