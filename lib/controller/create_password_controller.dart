import 'dart:convert';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/create_password/biomertrics_page.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password.dart';
import 'package:ems_v4/views/layout/private/create_password/create_pin.dart';
import 'package:ems_v4/views/layout/public/forgot_password/email_otp.dart';
import 'package:ems_v4/views/layout/public/forgot_password/new_password.dart';
import 'package:ems_v4/views/layout/public/forgot_password/otp_input_page.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class CreatePasswordController extends GetxController {
  final ApiCall apiCall = ApiCall();
  final RxBool isLoading = false.obs;

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
  }

  animateToThirdPage() {
    pageIndex.value = 2;
    pageController.value.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future sendForgotPasswordRequest(String? email) async {
    isLoading.value = true;
    if (email != null) {
      try {
        var response =
            await apiCall.postRequest({'email': email}, '/mail-reset-otp');
        var result = jsonDecode(response.body);
        if (result['success']) {
          await Get.dialog(
            barrierDismissible: false,
            GetDialog(
              type: 'success',
              title: 'One-Time Pin Sent',
              hasMessage: true,
              message: "An OTP has been sent to verify your email address",
              buttonNumber: 1,
              hasCustomWidget: true,
              withCloseButton: false,
              okPress: () {
                Get.back();
              },
              okText: "Close",
              okButtonBGColor: gray,
            ),
          );
          animateToSecondPage();
        } else {
          Get.dialog(
            const GetDialog(
              title: "Opps!",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: "Error Forgot Password: Something went wrong!",
              type: "error",
              buttonNumber: 0,
            ),
          );
        }
      } catch (e) {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Forgot Password: $e !",
            type: "error",
            buttonNumber: 0,
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
