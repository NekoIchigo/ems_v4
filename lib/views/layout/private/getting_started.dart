import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthController _authService = Get.find<AuthController>();
  final LocationController _locationController = Get.find<LocationController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFunction();
  }

  Future loadFunction() async {
    await _homeController.checkNewShift(
        employeeId: _authService.employee!.value.id);
    await _timeEntriesController.getAttendanceList(
        employeeId: _authService.employee!.value.id, days: 1);
    await _locationController.checkLocationPermission();
    await _timeEntriesController.getPreviousClockIn();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Getting things started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              LoadingAnimationWidget.prograssiveDots(
                color: Colors.white,
                size: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
