import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EMSContainer extends StatefulWidget {
  final Widget child;
  const EMSContainer({super.key, required this.child});

  @override
  State<EMSContainer> createState() => _EMSContainerState();
}

class _EMSContainerState extends State<EMSContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * .16,
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 35),
                color: bgPrimaryBlue,
                child: Image.asset(
                  'assets/images/EMS_logo.png',
                  height: 50,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height * .86,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
