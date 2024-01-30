import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeResultPage extends StatefulWidget {
  const HomeResultPage({super.key});

  @override
  State<HomeResultPage> createState() => _HomeResultPageState();
}

class _HomeResultPageState extends State<HomeResultPage> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Lottie.asset(
            "assets/lottie/success-icon-5.json",
            repeat: false,
            width: 100,
          ),
          // child: Lottie.asset(widget.passed ? "assets/lottie/success-icon-5.json" : "assets/lottie/error-icon-2.json", repeat: false, width: 100),
        ),
        Obx(
          () => Text(
            // "Successful ${widget.isClockIn ? "clock-in" : "clock-out"}",
            "Successful ${_homeController.isClockOut.isFalse ? 'clock-out' : 'clock-in'}",
            style: const TextStyle(
              fontSize: 13,
              color: gray,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          DateFormat('MMM d, yyyy, hh:mm a').format(DateTime.now()),
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: gray),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: RoundedCustomButton(
            onPressed: () {
              _homeController.isWhite.value = false;
              _homeController.pageName('/home');
            },
            label: 'Close',
            size: Size(Get.width * .8, 40),
            bgColor: bgPrimaryBlue,
            radius: 10,
          ),
        ),
      ],
    );
  }
}
