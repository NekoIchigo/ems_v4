import 'package:ems_v4/views/layout/private/create_password/biomertrics_page.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password.dart';
import 'package:ems_v4/views/layout/private/create_password/create_pin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePasswordController extends GetxController {
  final List<Widget> pages = [
    const CreatePassword(),
    const CreatePin(),
    const BiometricsPage(),
  ];
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
  final pageController = PageController(initialPage: 0);
}
