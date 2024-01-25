import 'package:ems_v4/views/layout/private/create_password/biomertrics_page.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password.dart';
import 'package:ems_v4/views/layout/private/create_password/create_pin.dart';
import 'package:ems_v4/views/layout/public/forgot_password/email_otp.dart';
import 'package:ems_v4/views/layout/public/forgot_password/new_password.dart';
import 'package:ems_v4/views/layout/public/forgot_password/otp_input_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePasswordController extends GetxController {
  final List<Widget> pages = [
    const CreatePassword(),
    const CreatePin(),
    const BiometricsPage(),
  ];

  final List<Widget> forgotPasswordPages = [
    const EmailOTP(),
    const OTPInputPage(),
    const NewPassword(),
  ];

  late Rx<AnimationController> midController;
  late Rx<Animation<double>> midAnimation;
  late Rx<Animation<Color?>> midBackgroundColorAnimation;
  late Rx<Animation<Color?>> midIconColorAnimation;

  late Rx<AnimationController> lastController;
  late Rx<Animation<double>> lastAnimation;
  late Rx<Animation<Color?>> lastBackgroundColorAnimation;
  late Rx<Animation<Color?>> lastIconColorAnimation;

  final List<String> titles = [
    "Create Password",
    "Create Pin",
    "Biometrics",
  ];

  final List<String> subtitles = [
    "Create a password by following the instructions below.",
    "Create a PIN to serve as your password to log in.",
    "Enable your biometrics for faster and easier access to your account.",
  ];

  RxInt pageIndex = 0.obs;
  Rx<PageController> pageController = PageController(initialPage: 0).obs;

  animateReturnToFirstPage() {
    // midController.value.reverse();
    // lastController.value.reverse();
    pageIndex.value = 0;
    pageController.value.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  animateToSecondPage() {
    pageIndex.value = 1;
    pageController.value.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // if (midController.value.status != AnimationStatus.completed) {
    //   midController.value.reset();
    //   midController.value.forward();
    // }
    // lastController.value.reverse();
  }

  animateToThirdPage() {
    pageIndex.value = 2;
    pageController.value.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    // if (lastController.value.status != AnimationStatus.completed) {
    //   lastController.value.reset();
    //   lastController.value.forward();
    // }
  }
}