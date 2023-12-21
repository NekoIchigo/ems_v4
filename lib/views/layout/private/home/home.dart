import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Settings _settings = Get.find<Settings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Center(
        child: Obx(
          () => Text(
            DateFormat("hh:mm a").format(
              _settings.currentTime.value,
            ),
          ),
        ),
      ),
    );
  }
}
