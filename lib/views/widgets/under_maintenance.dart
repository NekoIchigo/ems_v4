import 'package:flutter/material.dart';
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
          children: [
            Lottie.asset(
              "assets/lottie/maintenance.json",
              width: 300,
            ),
            const Text(
              'Sorry! The system is under maintenance',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
