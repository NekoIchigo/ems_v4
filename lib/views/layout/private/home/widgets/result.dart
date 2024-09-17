import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeResultPage extends StatefulWidget {
  const HomeResultPage({super.key});

  @override
  State<HomeResultPage> createState() => _HomeResultPageState();
}

class _HomeResultPageState extends State<HomeResultPage> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(
      () => Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Icon(
                _homeController.isUserSick.isTrue
                    ? Icons.error
                    : Icons.check_circle,
                color: _homeController.isUserSick.isTrue
                    ? colorError
                    : bgSecondaryBlue,
                size: 100,
              )
              // ColorFiltered(
              //   colorFilter:
              //       const ColorFilter.mode(bgSecondaryBlue, BlendMode.difference),
              //   child: Lottie.asset(
              //     _homeController.isUserSick.isTrue
              //         ? "assets/lottie/error-icon-2.json"
              //         : "assets/lottie/success-icon-4.json",
              //     repeat: false,
              //     width: 100,
              //   ),
              // ),
              // child: Lottie.asset(widget.passed ? "assets/lottie/success-icon-5.json" : "assets/lottie/error-icon-2.json", repeat: false, width: 100),
              ),
          Visibility(
            visible: _homeController.isUserSick.isTrue,
            child: SizedBox(
              width: size.width * .8,
              child: const Column(
                children: [
                  Text(
                    "Symptoms found!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorError,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Please report to your HR Department immediately",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorError,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            // "Successful ${widget.isClockIn ? "clock-in" : "clock-out"}",
            "Successful ${_homeController.isClockOut.isFalse ? 'clock-out' : 'clock-in'}",
            style: const TextStyle(
              fontSize: 14,
              color: gray700,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('MMM d, yyyy, hh:mm a').format(DateTime.now()),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: gray700),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RoundedCustomButton(
              onPressed: () {
                context.go('/in_out');
              },
              label: 'Close',
              size: Size(size.width * .8, 40),
              bgColor: _homeController.isUserSick.isTrue ? gray : bgPrimaryBlue,
              radius: 10,
            ),
          ),
        ],
      ),
    );
  }
}
