import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NoInternet extends StatelessWidget {
  NoInternet({super.key});
  final SettingsController _settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String? path = GoRouterState.of(context).extra as String?;

    if (path != null) {
      _settings.currentPath.value = path;
    }

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
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * .15),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          'assets/images/no_internet.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No connection',
                      style: TextStyle(color: darkGray, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: size.width * .8,
                      child: Text(
                        'We\'ll need your location to give you a better experience ${path ?? _settings.currentPath.value}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: darkGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RoundedCustomButton(
                      onPressed: () {
                        context.go(path ?? _settings.currentPath.value);
                      },
                      bgColor: bgPrimaryBlue,
                      label: 'Try Again',
                      size: Size(size.width * .8, 50),
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
