import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/attendance.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  final DateTimeUtils dateTimeUtils = DateTimeUtils();

  RxString pageName = ''.obs, currentLocation = ''.obs;
  RxBool isWhite = false.obs,
      isOustideVicinity = false.obs,
      isLoading = false.obs,
      isClockOut = false.obs,
      isClockInOutComplete = false.obs;
  Rx<Attendance> attendance = Attendance().obs;

  Future getLatestLog({
    required int employeeId,
  }) async {
    isLoading.value = true;
    try {
      var response = await apiCall.getRequest('/latest-dtr/$employeeId');
      var result = jsonDecode(response.body);
      var serverTime = await apiCall.getRequest('/server-time');
      var timeResult = jsonDecode(serverTime.body);

      if (result['success']) {
        int dayDifference = -1;
        if (result['data'] != null) {
          dayDifference = dateTimeUtils.calculateDateTimeDifference(
            timeResult['data']['withTimeZone'],
            result['data']['clock_in_at'],
            'days',
          );

          if (dayDifference == 0) {
            attendance = Attendance.fromJson(result['data']).obs;
            if (result['data']['clock_in_at'] != null &&
                result['data']['clock_out_at'] == null) {
              attendance = Attendance.fromJson(result['data']).obs;
              isClockOut.value = true;
              isClockInOutComplete.value = false;
            } else {
              isClockOut.value = false;
              isClockInOutComplete.value = true;
            }
          }
        }
      } else {
        Get.dialog(GetDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ));
        pageName.value = '/home';
        printError(info: 'Error Message getLatestLog: Invalid Request');
        pageName.value = '/home';
      }
      isLoading.value = false;
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ));
      pageName.value = '/home';
      printError(info: 'Error Message getLatestLog: $error');
      isLoading.value = false;
      pageName.value = '/home';
    }

    return;
  }

  Future setClockInLocation() async {
    isLoading.value = true;
    // TODO: must get the location from googlemaps api

    // attendance.value.clockedInLocation = description;
    // attendance.value.clockedInLattitude = lattitude;
    // attendance.value.clockedInLongitude = longitude;

    currentLocation.value = 'EDSA Shaw Starmall, Mandaluyong City';

    attendance.value.clockedInLocation = currentLocation.value;
    attendance.value.clockedInLattitude = '14.5828';
    attendance.value.clockedInLongitude = '121.0535';
    attendance.value.clockedInLocationType = 'Within Vicinity';
    attendance.value.clockedInLocationSetting = '';
    isLoading.value = false;
  }

  Future setClockOutLocation() async {
    isLoading.value = true;

    // TODO: must get the location from googlemaps api

    // attendance.value.clockedOutLocation = description;
    // attendance.value.clockedOutLattitude = lattitude;
    // attendance.value.clockedOutLongitude = longitude;

    currentLocation.value = 'EDSA Shaw Starmall, Mandaluyong City';

    attendance.value.clockedOutLocation = currentLocation.value;
    attendance.value.clockedOutLattitude = '14.5828';
    attendance.value.clockedOutLongitude = '121.0535';
    attendance.value.clockedInLocationType = 'Within Vicinity';
    attendance.value.clockedInLocationSetting = '';
    isLoading.value = false;
  }

  Future clockIn({
    required int employeeId,
    required BuildContext context,
    List healthCheck = const [],
    String temperature = '',
  }) async {
    isLoading.value = true;
    String healthCheckStr = healthCheck.join(', ');
    try {
      // print('called');
      var response = await apiCall.postRequest({
        'employee_id': employeeId,
        'clocked_in_location': attendance.value.clockedInLocation,
        'clocked_in_lattitude': attendance.value.clockedInLattitude,
        'clocked_in_longitude': attendance.value.clockedInLongitude,
        'clocked_in_location_type': attendance.value.clockedInLocationType,
        'clocked_in_location_setting':
            attendance.value.clockedInLocationSetting,
        'health_check': healthCheckStr,
        'health_temperature': temperature,
      }, '/clock-in');
      var result = jsonDecode(response.body);
      if (result['success']) {
        attendance.value.id = result['data']['id'];
        isClockOut.value = true;
        getLatestLog(employeeId: authService.employee.value.id);
      } else {
        Get.dialog(GetDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ));
      }
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ));
      printError(info: 'Error Message: $error');
      isLoading.value = false;
      pageName.value = '/home';
    } finally {
      isLoading.value = false;
    }
  }

  Future clockOut({required BuildContext context}) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'attendance_id': attendance.value.id,
        'clocked_out_location': attendance.value.clockedOutLocation,
        'clocked_out_lattitude': attendance.value.clockedOutLattitude,
        'clocked_out_longitude': attendance.value.clockedInLongitude,
        'clocked_out_location_type': attendance.value.clockedInLocationType,
        'clocked_out_location_setting':
            attendance.value.clockedInLocationSetting,
      }, '/clock-out');
      var result = jsonDecode(response.body);
      if (result['success']) {
        // attendance.value.id = result['data']['id'];
        // isClockOut.value = false;
        // isClockInOutComplete.value = true;

        getLatestLog(employeeId: authService.employee.value.id);
      } else {
        Get.dialog(GetDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ));

        pageName.value = '/home';
      }

      isLoading.value = false;
    } catch (error) {
      Get.dialog(GetDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ));
    } finally {
      isLoading.value = false;
      pageName.value = '/home';
    }
  }

  String getWorkingHrs({
    required String dateTimeIn,
    required String dateTimeOut,
  }) {
    if (dateTimeIn != "" && dateTimeOut != "") {
      DateTime timein = DateTime.parse(dateTimeIn);
      DateTime timeout = DateTime.parse(dateTimeOut);

      // Calculate the difference in minutes
      Duration difference = timeout.difference(timein);

      // Calculate hours and remaining minutes
      int hours = difference.inHours;
      int remainingMinutes = difference.inMinutes.remainder(60);

      return "$hours : $remainingMinutes";
    } else {
      return "?? : ??";
    }
  }
}
