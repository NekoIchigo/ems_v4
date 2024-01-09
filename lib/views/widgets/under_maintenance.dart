import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderMaintenance extends StatefulWidget {
  const UnderMaintenance({super.key});

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/lottie/under_development.json",
            width: 300,
          ),
          const Text(
            'This page is still under development',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
