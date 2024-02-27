import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UnderMaintenance extends StatefulWidget {
  final bool hasLogo;
  const UnderMaintenance({super.key, required this.hasLogo});

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: Get.height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Image.asset(
                    'assets/images/GEMS4blue.png',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Lottie.asset(
              "assets/lottie/under_development.json",
              width: 300,
            ),
            const SizedBox(height: 30),
            const Text(
              "Under Maintenance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: darkGray),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Get.width * .8,
              child: const Text(
                "The page you're looking for is currently under maintenance and will be back soon.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: darkGray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
