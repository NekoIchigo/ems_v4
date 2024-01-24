// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:ems_v4/global/constants.dart';

class PasswordValidation extends StatefulWidget {
  const PasswordValidation({super.key});

  @override
  State<PasswordValidation> createState() => _PasswordValidationState();
}

class _PasswordValidationState extends State<PasswordValidation> {
  List<Validation> validations = [
    Validation(label: "10 characters", regExp: RegExp(r'.{10,}')),
    Validation(label: "1 uppercase letter", regExp: RegExp(r'(?=.*[A-Z])')),
    Validation(label: "1 lowercase letter", regExp: RegExp(r'(?=.*[a-z])')),
    Validation(label: "1 number", regExp: RegExp(r'(?=.*\d)')),
    Validation(label: "1 symbol", regExp: RegExp(r'(?=.*[^A-Za-z0-9])')),
    Validation(label: "10 characters", regExp: RegExp(r'.{10,}')),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password must contain at least",
            style: TextStyle(color: gray),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValidationText(label: "10 characters", isValid: true),
                  ValidationText(label: "1 uppercase letter", isValid: false),
                  ValidationText(label: "1 lowercase letter", isValid: true),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValidationText(label: "1 symbol", isValid: true),
                  ValidationText(label: "1 number", isValid: true),
                  ValidationText(label: "Match Password", isValid: false),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ValidationText extends StatefulWidget {
  final String label;
  final bool isValid;
  const ValidationText({super.key, required this.label, required this.isValid});

  @override
  State<ValidationText> createState() => _ValidationTextState();
}

class _ValidationTextState extends State<ValidationText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.isValid
            ? LottieBuilder.asset(
                'assets/lottie/thumbs-up.json',
                repeat: false,
                width: 25,
              )
            : LottieBuilder.asset(
                'assets/lottie/thumbs-down.json',
                repeat: false,
                width: 25,
              ),
        Text(widget.label, style: TextStyle(color: gray)),
      ],
    );
  }
}

class Validation {
  String label;
  RegExp regExp;
  Validation({
    required this.label,
    required this.regExp,
  });
}
