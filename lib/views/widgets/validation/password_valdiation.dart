import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ems_v4/global/constants.dart';

class PasswordValidation extends StatefulWidget {
  const PasswordValidation({super.key});

  @override
  State<PasswordValidation> createState() => _PasswordValidationState();
}

class _PasswordValidationState extends State<PasswordValidation> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();

  RegExp minimumChar = RegExp(r'.{10,}');
  RegExp hasUpperCase = RegExp(r'(?=.*[A-Z])');
  RegExp hasLowerCase = RegExp(r'(?=.*[a-z])');
  RegExp hasNumber = RegExp(r'(?=.*\d)');
  RegExp hasSymbol = RegExp(r'(?=.*[^A-Za-z0-9])');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password must contain at least",
            style: TextStyle(color: gray),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValidationText(
                      label: "10 characters",
                      isValid: minimumChar
                          .hasMatch(_createPasswordController.password.value),
                    ),
                    ValidationText(
                      label: "1 uppercase letter",
                      isValid: hasUpperCase
                          .hasMatch(_createPasswordController.password.value),
                    ),
                    ValidationText(
                      label: "1 lowercase letter",
                      isValid: hasLowerCase
                          .hasMatch(_createPasswordController.password.value),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValidationText(
                      label: "1 symbol",
                      isValid: hasSymbol
                          .hasMatch(_createPasswordController.password.value),
                    ),
                    ValidationText(
                      label: "1 number",
                      isValid: hasNumber
                          .hasMatch(_createPasswordController.password.value),
                    ),
                    ValidationText(
                      label: "Match Password",
                      isValid: _createPasswordController.password.value ==
                          _createPasswordController.confirmPassword.value,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ValidationText extends StatelessWidget {
  final String label;
  final bool isValid;
  const ValidationText({super.key, required this.label, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isValid
            ? const Icon(
                Icons.thumb_up,
                color: colorSuccess,
                size: 15,
              )
            : const Icon(
                Icons.thumb_down,
                color: colorError,
                size: 15,
              ),
        // ? LottieBuilder.asset(
        //     'assets/lottie/thumbs-up.json',
        //     repeat: false,
        //     width: 25,
        //   )
        // : LottieBuilder.asset(
        //     'assets/lottie/thumbs-down.json',
        //     repeat: false,
        //     width: 25,
        //   ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: gray)),
      ],
    );
  }
}
