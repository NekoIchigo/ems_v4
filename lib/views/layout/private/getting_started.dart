import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  final AuthController _auth = Get.find<AuthController>();
  final HomeController _homeController = Get.find<HomeController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  @override
  void initState() {
    super.initState();
    loadFunction();
  }

  Future loadFunction() async {
    _homeController.isGettingStarted.value = true;
    await _auth.updateEmployeeInfo();
    await _timeEntriesController.getAttendanceList(days: 1);
    await _timeEntriesController.getPreviousClockIn();
    await _settings.getServerTime();
    await _homeController.checkNewShift();
    _homeController.isGettingStarted.value = false;

    if (_homeController.isDropdownEnable.isFalse ||
        _homeController.isFirstShiftComplete.value) {
      _homeController.initialDropdownString.value =
          _homeController.scheduleList.first;
      if (_homeController.attendance.value.scheduleId != null &&
          int.parse(_homeController.attendance.value.scheduleId!) ==
              _homeController.scheduleId2.value) {
        _homeController.initialDropdownString.value =
            _homeController.scheduleList[1];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: _homeController.isGettingStarted.value,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: LoadingAnimationWidget.inkDrop(
              color: primaryBlue,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
