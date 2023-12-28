import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: Get.height * .78,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lottie/under_development.json",
                width: 300,
              ),
              const Text(
                'This page is still under development',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              RoundedCustomButton(
                onPressed: () {
                  if (authService.isLoading.isFalse) {
                    authService.logout(context);
                  }
                },
                label: 'Log out',
                size: Size(Get.width, 30),
                bgColor: bgPrimaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
