import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/location_controller.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  final SettingsController _settings = Get.find<SettingsController>();
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();
  final LocationController _locationController = Get.find<LocationController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  @override
  void initState() {
    super.initState();
    // _homeController.getLatestLog(employeeId: _authService.employee.value.id);
    _homeController.checkNewShift(employeeId: _authService.employee!.value.id);
    _timeEntriesController.getAttendanceList(
        employeeId: _authService.employee!.value.id, days: 1);
    _locationController.checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: _settings.isLoading.isTrue,
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
      ),
    );
  }
}
