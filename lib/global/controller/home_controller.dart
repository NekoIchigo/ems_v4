import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthController _authService = Get.find<AuthController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  final ApiCall apiCall = ApiCall();
  final DateTimeUtils dateTimeUtils = DateTimeUtils();
  final SettingsController _settings = Get.find<SettingsController>();

  RxInt scheduleId1 = 0.obs, scheduleId2 = 0.obs, currentScheduleId = 0.obs;

  Rx<String> workStart = "??:??".obs,
      workEnd = "??:??".obs,
      workStart2 = "??:??".obs,
      restday = "".obs,
      restday2 = "".obs,
      greetings = "Begin another day by clocking in.".obs,
      workEnd2 = "??:??".obs;

  RxString currentLocation = ''.obs;
  RxList<String> scheduleList = ["-- Select --", ""].obs;
  RxBool isInsideVicinity = false.obs,
      hasClockOutsideVicinity = false.obs,
      isLoading = false.obs,
      isClockOut = false.obs,
      isClockInOutComplete = false.obs,
      isUserSick = false.obs,
      isMobileUser = false.obs,
      isSecondShift = false.obs,
      hasSecondShift = false.obs,
      isDropdownEnable = false.obs,
      isNewShift = false.obs;

  Rx<AttendanceRecord> attendance = AttendanceRecord().obs;

  void reset() async {
    isInsideVicinity = false.obs;
    isClockOut = false.obs;
    isClockInOutComplete = false.obs;
    isUserSick = false.obs;
    isNewShift = false.obs;

    attendance = AttendanceRecord().obs;
    workStart.value = "??:??";
    workEnd.value = "??:??";
    workStart2.value = "??:??";
    workEnd2.value = "??:??";
    restday.value = "";
    restday2.value = "";
  }

  void decideGreetingsValue() {
    greetings.value = isClockInOutComplete.isTrue
        ? 'See you tomorrow'
        : isClockOut.isTrue
            ? 'Have a great day at work!'
            : 'Begin another day by clocking in.';
  }

  Future checkNewShift() async {
    isLoading.value = true;

    var result = await apiCall.getRequest(
      apiUrl: '/mobile/check-shift/1',
      catchError: (error) => isLoading.value = false,
    );
    if (result.containsKey('success') && result['success']) {
      var data = result['data'];

      isNewShift.value = data['is_new_shift'];
      isClockInOutComplete.value = data['is_shift_complete'];
      isClockOut.value = data['is_clockout'];
      workStart.value = data['work_start'];
      isMobileUser.value = data['is_mobile_user'];
      workEnd.value = data['work_end'];
      workStart2.value = data['work_start2'] ?? "";
      workEnd2.value = data['work_end2'] ?? "";
      restday.value = data['restday'] ?? "";
      restday2.value = data['restday2'] ?? "";
      scheduleId1.value = data['schedule_id'];
      scheduleId2.value = data['schedule_id2'] ?? 0;

      hasSecondShift.value = scheduleId2.value != 0;
      isDropdownEnable.value = hasSecondShift.isTrue && isClockOut.isFalse;

      scheduleList[0] =
          '${workStart.value} to ${workEnd.value}, Restday ${restday.value}';
      if (scheduleId2.value != 0) {
        scheduleList[1] =
            '${workStart2.value} to ${workEnd2.value}, Restday ${restday2.value}';
      }

      if (data['current_attendance_record'] != null) {
        print(data['current_attendance_record']);
        attendance =
            AttendanceRecord.fromJson(data['current_attendance_record']).obs;
      } else {
        attendance = AttendanceRecord().obs;
      }
      decideGreetingsValue();
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Check Shift: ${result['message']}",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }

    isLoading.value = false;
  }

  Future checkCurrentAttendanceRecordBySchedule() async {
    isLoading.value = true;
    apiCall.getRequest(apiUrl: 'apiUrl').then((value) {}).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future setClockInLocation() async {
    isLoading.value = true;
    await _settings.checkLocationService('/in_out');
    await _settings.checkLocationPermission('/in_out');

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var result = await apiCall.postRequest(
      data: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      apiUrl: '/mobile/calculate-location/${_authService.employee!.value.id}',
      catchError: (error) => isLoading.value = false,
    );

    if (result.containsKey('success') && result['success']) {
      var data = result['data'];
      isInsideVicinity.value = data['is_inside_vicinity'];
      currentLocation.value =
          "Your distance is ${data['distance_in_km']} km from your work location";
      attendance.value.clockedInLocation = currentLocation.value;
      attendance.value.clockedInLatitude = position.latitude.toString();
      attendance.value.clockedInLongitude = position.longitude.toString();
      attendance.value.clockedInLocationType =
          isInsideVicinity.isTrue ? 'Within Vicinity' : 'Outside Vicinity';
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: Distance calculation unsuccessful",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }

    isLoading.value = false;
  }

  Future setClockOutLocation() async {
    isLoading.value = true;
    await _settings.checkLocationService('/in_out');
    await _settings.checkLocationPermission('/in_out');

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var result = await apiCall.postRequest(
      data: {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      apiUrl: '/mobile/calculate-location/${_authService.employee!.value.id}',
      catchError: (error) => isLoading.value = false,
    );
    if (result.containsKey('success') && result['success']) {
      var data = result['data'];
      isInsideVicinity.value = data['is_inside_vicinity'];
      currentLocation.value =
          "Your distance is ${data['distance_in_km']} km from your work location";
      attendance.value.clockedOutLocation = currentLocation.value;
      attendance.value.clockedOutLatitude = position.latitude.toString();
      attendance.value.clockedOutLongitude = position.longitude.toString();
      attendance.value.clockedOutLocationType =
          isInsideVicinity.isTrue ? 'Within Vicinity' : 'Outside Vicinity';
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return const GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: Distance calculation unsuccessful",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }

    isLoading.value = false;
  }

  Future clockIn({
    List healthCheck = const [],
    String? temperature,
  }) async {
    isLoading.value = true;
    String healthCheckStr = healthCheck.join(', ');
    double userTemperature = 37.0;

    if (temperature != null) {
      userTemperature = double.parse(temperature);
    }

    if (healthCheck.isNotEmpty || userTemperature >= 37.8) {
      isUserSick.value = true;
    } else {
      isUserSick.value = false;
    }

    var result = await apiCall.postRequest(
      data: {
        'employee_id': _authService.employee!.value.id,
        'clocked_in_location': attendance.value.clockedInLocation,
        'clocked_in_latitude': attendance.value.clockedInLatitude,
        'clocked_in_longitude': attendance.value.clockedInLongitude,
        'clocked_in_location_type': attendance.value.clockedInLocationType,
        'clocked_in_location_setting':
            attendance.value.clockedInLocationSetting,
        'schedule_id':
            isSecondShift.isTrue ? scheduleId2.value : scheduleId1.value,
        'health_check': healthCheckStr,
        'health_temperature': temperature,
      },
      apiUrl: '/mobile/clock-in',
      catchError: () {},
    );
    if (result.containsKey('success') && result['success']) {
      _timeEntriesController.getAttendanceList(days: 1);
      checkNewShift();
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: $result",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }
  }

  Future clockOut({required BuildContext context}) async {
    isLoading.value = true;
    final data = {
      'attendance_id': attendance.value.id,
      'clocked_out_location': attendance.value.clockedOutLocation,
      'clocked_out_latitude': attendance.value.clockedOutLatitude,
      'clocked_out_longitude': attendance.value.clockedOutLongitude,
      'clocked_out_location_type': attendance.value.clockedOutLocationType,
      'clocked_out_location_setting':
          attendance.value.clockedOutLocationSetting,
    };

    var result = await apiCall.postRequest(
      data: data,
      apiUrl: '/mobile/clock-out',
      catchError: () {},
    );

    if (result.containsKey('success') && result['success']) {
      _timeEntriesController.getAttendanceList(days: 1);
      checkNewShift();
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error clock out result: $result",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    }
  }

  String getWorkingHrs({DateTime? dateTimeIn, DateTime? dateTimeOut}) {
    if (dateTimeIn != null && dateTimeOut != null) {
      // Calculate the difference in minutes
      Duration difference = dateTimeOut.difference(dateTimeIn);

      // Calculate hours and remaining minutes
      int hours = difference.inHours;
      int remainingMinutes = difference.inMinutes.remainder(60);

      return "$hours : $remainingMinutes";
    } else {
      return "?? : ??";
    }
  }
}
