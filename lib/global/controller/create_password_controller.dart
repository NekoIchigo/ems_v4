import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/layout/private/create_password/biomertrics_page.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password.dart';
import 'package:ems_v4/views/layout/private/create_password/create_pin.dart';
import 'package:ems_v4/views/layout/public/forgot_password/email_otp.dart';
import 'package:ems_v4/views/layout/public/forgot_password/new_password.dart';
import 'package:ems_v4/views/layout/public/forgot_password/otp_input_page.dart';
import 'package:ems_v4/views/layout/public/forgot_pin/new_pin.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePasswordController extends GetxController {
  late SharedPreferences _localStorage;

  final ApiCall apiCall = ApiCall();

  RxString password = ''.obs, confirmPassword = ''.obs;
  String? _errorText;
  RxBool isForgotPin = false.obs, isLoading = false.obs;

  final List<Widget> pages = [
        const CreatePassword(),
        const CreatePin(),
        const BiometricsPage(),
      ],
      forgotPasswordPages = [
        const EmailOTP(),
        const OTPInputPage(),
        const NewPassword(),
      ],
      forgotPINPages = [
        const EmailOTP(),
        const OTPInputPage(),
        const NewPIN(),
      ];

  late Rx<AnimationController> midController, lastController;
  late Rx<Animation<double>> midAnimation, lastAnimation;
  late Rx<Animation<Color?>> midBackgroundColorAnimation,
      lastBackgroundColorAnimation;
  late Rx<Animation<Color?>> midIconColorAnimation, lastIconColorAnimation;

  String _userEmail = '';

  final List<String> titles = [
        "Create Password",
        "Create Pin",
        "Biometrics",
      ],
      subtitles = [
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

      var result = await apiCall.postRequest(
          data: {'email': email},
          apiUrl: '/mail-reset-otp',
          catchError: (error) => isLoading.value = false);
      if (result.containsKey('success') && result['success']) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return const GemsDialog(
              type: 'success',
              title: 'One-Time Pin Sent',
              hasMessage: true,
              message: "An OTP has been sent to verify your email address",
              buttonNumber: 0,
              hasCustomWidget: false,
              withCloseButton: true,
              okButtonBGColor: gray,
            );
          },
        );
        animateToSecondPage();
      } else {
        _errorText = result['message'];
      }

      isLoading.value = false;
    }
    return _errorText;
  }

  Future verifyOTP(String? otpPin) async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      'OTPin': otpPin,
      'email': _userEmail,
    };
    var result = await apiCall.postRequest(
        data: data,
        apiUrl: '/otp-validation',
        catchError: (error) => isLoading.value = false);
    if (result.containsKey('success') && result['success']) {
      animateToThirdPage();
    } else {
      isLoading.value = false;
      return result;
    }

    isLoading.value = false;
  }

  Future setNewPassword(String? password, String? confirmPassword) async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      'password': password,
      'password_confirmation': confirmPassword,
      'email': _userEmail
    };
    var result = await apiCall.postRequest(
      data: data,
      apiUrl: '/reset-password',
      catchError: (error) => isLoading.value = false,
    );
    if (result.containsKey('success') && result['success']) {
      await showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return const GemsDialog(
              type: 'success',
              title: 'Success!',
              hasMessage: true,
              message: "You can now log in using your new password.",
              buttonNumber: 0,
              hasCustomWidget: false,
              withCloseButton: true,
              okButtonBGColor: bgPrimaryBlue,
            );
          });
      navigatorKey.currentContext!.go("/login");
    } else {
      isLoading.value = false;
      return result;
    }

    isLoading.value = false;
  }

  Future createNewPassword(
    String password,
    String confirmPassword,
    String? currentPassword,
  ) async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      'password': password,
      'password_confirmation': confirmPassword,
      'current_password': currentPassword,
    };
    var result = await apiCall.postRequest(
      data: data,
      apiUrl: '/change-password',
      catchError: (error) => isLoading.value = false,
    );

    if (result.containsKey('success') && result['success']) {
      if (currentPassword != null) {
        await showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return const GemsDialog(
                type: 'success',
                title: 'Success',
                hasMessage: true,
                message: "You can now log in using your new password.",
                buttonNumber: 0,
                hasCustomWidget: false,
                withCloseButton: true,
                okButtonBGColor: bgPrimaryBlue,
              );
            });
        navigatorKey.currentContext!.go("/login");
      } else {
        animateToSecondPage();
      }
    } else {
      isLoading.value = false;
      return result;
    }
    isLoading.value = false;
  }

  Future changePIN(
    String pin,
    String confirmPin, {
    String? currentpin,
  }) async {
    isLoading.value = true;

    final Map<String, dynamic> data = {
      'pin': pin,
      'pin_confirmation': confirmPin,
      'current_pin': currentpin,
    };
    var result = await apiCall.postRequest(
      data: data,
      apiUrl: '/change-pin',
      catchError: (error) => isLoading.value = false,
    );

    if (result.containsKey('success') && result['success']) {
      if (currentpin != null) {
        await showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return const GemsDialog(
                type: 'success',
                title: 'Success',
                hasMessage: true,
                message: "You can now log in using your new PIN.",
                buttonNumber: 0,
                hasCustomWidget: false,
                withCloseButton: true,
                okButtonBGColor: bgPrimaryBlue,
              );
            });
        navigatorKey.currentContext!.go("/login");
      } else if (isForgotPin.isTrue) {
        await showDialog(
            barrierDismissible: false,
            context: navigatorKey.currentContext!,
            builder: (context) {
              return const GemsDialog(
                type: 'success',
                title: 'Success',
                hasMessage: true,
                message: "You can now log in using your new PIN.",
                buttonNumber: 0,
                hasCustomWidget: false,
                withCloseButton: true,
                okButtonBGColor: bgPrimaryBlue,
              );
            });
        isForgotPin.value = false;
        navigatorKey.currentContext!.go("/pin_login");
      } else {
        animateToThirdPage();
      }
    } else {
      isLoading.value = false;
      return result;
    }

    isLoading.value = false;
  }

  Future enableBioMetrics(bool biometrics) async {
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;

    var result = await apiCall.getRequest(
      apiUrl: '/first-login',
      catchError: (error) => isLoading.value = false,
    );
    _localStorage.setBool('auth_biometrics', biometrics);

    if (result.containsKey('success') && result['success']) {
      await showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return GemsDialog(
              type: 'success',
              title: 'You are all set!',
              hasMessage: true,
              message: "Tap the login button to access your account.",
              buttonNumber: 1,
              hasCustomWidget: false,
              withCloseButton: true,
              okPress: () {
                navigatorKey.currentContext!.pop();
              },
              okText: 'Log in',
              okButtonBGColor: bgPrimaryBlue,
            );
          });
      navigatorKey.currentContext!.go("/login");
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Create PIN: ${result['message']}",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }

    isLoading.value = false;
  }
}
