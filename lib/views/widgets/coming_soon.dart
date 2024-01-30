import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 80,
          child: Lottie.asset("assets/lottie/coming_soon.json",
              width: Get.width * .55),
        ),
        Positioned(
          top: 100,
          child: Image.asset(
            'assets/images/coming_soon.jpg',
            width: Get.width * .70,
          ),
        ),
      ],
    );
  }
}
