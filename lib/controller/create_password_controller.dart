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
import 'package:shared_preferences/shared_preferences.dart';

class CreatePasswordController extends GetxController {
  late SharedPreferences _localStorage;

  final ApiCall apiCall = ApiCall();
  final RxBool isLoading = false.obs;

  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;

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
  String _userEmail = '';

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
      _userEmail = email;
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

  Future verifyOTP(String? OTPin) async {
    isLoading.value = true;

    try {
      var response = await apiCall.postRequest({
        'OTPin': OTPin,
        'email': _userEmail,
      }, '/otp-validition');
      var result = jsonDecode(response.body);
      if (result['success']) {
        // await Get.dialog(
        //   barrierDismissible: false,
        //   GetDialog(
        //     type: 'success',
        //     title: 'OTP Verified',
        //     hasMessage: true,
        //     message: "An OTP has been sent to verify your email address",
        //     buttonNumber: 1,
        //     hasCustomWidget: true,
        //     withCloseButton: false,
        //     okPress: () {
        //       Get.back();
        //     },
        //     okText: "Close",
        //     okButtonBGColor: gray,
        //   ),
        // );
        animateToThirdPage();
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error OTP: ${result['errorMessages']}",
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

  Future setNewPassword(String? password, String? confirmPassword) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'password': password,
        'password_confirmation': confirmPassword,
        'email': _userEmail
      }, '/reset-password');
      var result = jsonDecode(response.body);
      if (result['success']) {
        await Get.dialog(
          barrierDismissible: false,
          GetDialog(
            type: 'success',
            title: 'Password Updated',
            hasMessage: true,
            message: "You can now log in using your new password.",
            buttonNumber: 1,
            hasCustomWidget: true,
            withCloseButton: false,
            okPress: () {
              Get.back();
            },
            okText: "Log in",
            okButtonBGColor: bgPrimaryBlue,
          ),
        );
        Get.offNamed("/login");
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error New Password: ${result['errorMessages']}",
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

  Future createNewPassword(
    String password,
    String confirmPassword,
  ) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'password': password,
        'password_confirmation': confirmPassword,
      }, '/change-password');

      var result = jsonDecode(response.body);

      if (result['success']) {
        animateToSecondPage();
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Create Password: ${result['errorMessages']}",
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
          message: "Error Create Password: $e !",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future changePIN(
    String pin,
    String confirmPin,
  ) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'pin': pin,
        'pin_confirmation': confirmPin,
      }, '/change-pin');

      var result = jsonDecode(response.body);

      if (result['success']) {
        animateToThirdPage();
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Create PIN: ${result['errorMessages']}",
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
          message: "Error Create PIN: $e !",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future enableBioMetrics(bool biometrics) async {
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;

    try {
      var response = await apiCall.getRequest('/first-login');
      _localStorage.setBool('auth_biometrics', biometrics);

      var result = jsonDecode(response.body);

      if (result['success']) {
        Get.offNamed('/');
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Create PIN: ${result['errorMessages']}",
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
          message: "Error Create PIN: $e !",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
