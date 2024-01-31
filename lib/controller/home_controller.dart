import 'dart:convert';
import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/layout/private/home/widgets/health_declaration.dart';
import 'package:ems_v4/views/layout/private/home/widgets/in_out_page.dart';
import 'package:ems_v4/views/layout/private/home/widgets/information.dart';
import 'package:ems_v4/views/layout/private/home/widgets/result.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  final DateTimeUtils dateTimeUtils = DateTimeUtils();

  final int routerKey = 1;
  RxInt pageIndex = 0.obs;
  final List<Widget> pages = [
    const InOutPage(),
    const HomeInfoPage(),
    const HealthDeclaration(),
    const HomeResultPage()
  ];

  RxString pageName = ''.obs, currentLocation = ''.obs;
  RxBool isWhite = false.obs,
      isInsideVicinity = false.obs,
      isLoading = false.obs,
      isClockOut = false.obs,
      isClockInOutComplete = false.obs,
      isUserSick = false.obs,
      isNewShift = false.obs;

  Rx<AttendanceRecord> attendance = AttendanceRecord().obs;

  Future checkNewShift({required int employeeId}) async {
    isLoading.value = true;
    try {
      var response = await apiCall.getRequest('/check-shift/$employeeId');
      var result = jsonDecode(response.body);

      if (result.containsKey('success') && result['success']) {
        var data = result['data'];

        isNewShift.value = data['is_new_shift'];
        isClockInOutComplete.value = data['is_shift_complete'];
        isClockOut.value = data['is_clockout'];
        // print(result);
        log(result.toString());
        if (data['current_attendance_record'] != null) {
          attendance =
              AttendanceRecord.fromJson(data['current_attendance_record']).obs;
        } else {
          attendance = AttendanceRecord().obs;
        }
      } else {
        Get.dialog(
          GetDialog(
            title: "Oopps",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Check Shift: ${result['message']}",
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
    } catch (error) {
      printError(info: 'Check New Shift Error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future setClockInLocation() async {
    isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var response = await apiCall.postRequest(
        {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        '/calculate-location/${authService.employee.value.id}',
      );

      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        var data = result['data'];
        isInsideVicinity.value = data['is_inside_vicinity'];
        currentLocation.value =
            '${data['distance_in_km']} km away from designated office!';

        attendance.value.clockedInLocation = currentLocation.value;
        attendance.value.clockedInLatitude = position.latitude.toString();
        attendance.value.clockedInLongitude = position.longitude.toString();
        attendance.value.clockedInLocationType =
            isInsideVicinity.isTrue ? 'Within Vicinity' : 'Outside Vicinity';
      } else {
        Get.dialog(
          const GetDialog(
            title: "Oopps",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: Distance calculation unsuccessfull",
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
    } catch (error) {
      Get.dialog(
        GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: Unable to get your location \n Code: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future setClockOutLocation() async {
    isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var response = await apiCall.postRequest(
        {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        '/calculate-location/${authService.employee.value.id}',
      );
      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        var data = result['data'];
        isInsideVicinity.value = data['is_inside_vicinity'];
        currentLocation.value =
            '${data['distance_in_km']} km away from designated office!';
        attendance.value.clockedOutLocation = currentLocation.value;
        attendance.value.clockedOutLatitude = position.latitude.toString();
        attendance.value.clockedOutLongitude = position.longitude.toString();
        attendance.value.clockedOutLocationType =
            isInsideVicinity.isTrue ? 'Within Vicinity' : 'Outside Vicinity';
      } else {
        Get.dialog(
          const GetDialog(
            title: "Oopps",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: Distance calculation unsuccessfull",
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
    } catch (error) {
      Get.dialog(
        GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error:  Unable to get your location \n Code: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future clockIn({
    required int employeeId,
    List healthCheck = const [],
    String temperature = '',
  }) async {
    isLoading.value = true;
    String healthCheckStr = healthCheck.join(', ');
    double userTemperature = double.parse(temperature);

    if (healthCheck.isNotEmpty || userTemperature >= 37.8) {
      isUserSick.value = true;
    } else {
      isUserSick.value = false;
    }

    try {
      // print('called');
      var response = await apiCall.postRequest({
        'employee_id': employeeId,
        'clocked_in_location': attendance.value.clockedInLocation,
        'clocked_in_lattitude': attendance.value.clockedInLatitude,
        'clocked_in_longitude': attendance.value.clockedInLongitude,
        'clocked_in_location_type': attendance.value.clockedInLocationType,
        'clocked_in_location_setting':
            attendance.value.clockedInLocationSetting,
        'health_check': healthCheckStr,
        'health_temperature': temperature,
      }, '/clock-in');
      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        checkNewShift(employeeId: authService.employee.value.id);
      } else {
        Get.dialog(GetDialog(
          title: "Oopps",
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
        title: "Oopps",
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
        'clocked_out_lattitude': attendance.value.clockedOutLatitude,
        'clocked_out_longitude': attendance.value.clockedOutLongitude,
        'clocked_out_location_type': attendance.value.clockedOutLocationType,
        'clocked_out_location_setting':
            attendance.value.clockedOutLocationSetting,
      }, '/clock-out');
      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        checkNewShift(employeeId: authService.employee.value.id);
      } else {
        Get.dialog(GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error clock out result: $result",
          type: "error",
          buttonNumber: 0,
        ));

        pageName.value = '/home';
      }
    } catch (error) {
      Get.dialog(
        GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error clockout: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
      pageName.value = '/home';
    }
  }

  Future additionalShiftClockin(String reason, String location) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'attendance_records_id': attendance.value.id,
        'clocked_in_location': location,
        'clocked_in_lattitude': attendance.value.clockedInLatitude,
        'clocked_in_longitude': attendance.value.clockedInLongitude,
        'clocked_in_location_type': attendance.value.clockedInLocationType,
        'clocked_out_location_setting': reason,
      }, '/additional-shift-clockin');
      var result = jsonDecode(response.body);
      print(result);
    } catch (error) {
      Get.dialog(
        GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error clockout: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future additionalShiftClockout(String reason, String location) async {
    isLoading.value = true;
    try {
      var response = await apiCall.postRequest({
        'attendance_records_id': attendance.value.id,
        'clocked_in_location': location,
        'clocked_in_lattitude': attendance.value.clockedInLatitude,
        'clocked_in_longitude': attendance.value.clockedInLongitude,
        'clocked_in_location_type': attendance.value.clockedInLocationType,
        'clocked_out_location_setting': reason,
      }, '/additional-shift-clockout');
      var result = jsonDecode(response.body);
      print(result);
    } catch (error) {
      Get.dialog(
        GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error clockout: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
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

  // Future getLatestLog({required int employeeId}) async {
  //   isLoading.value = true;
  //   try {
  //     var response = await apiCall.getRequest('/latest-dtr/$employeeId');
  //     var result = jsonDecode(response.body);

  //     if (result['success']) {
  //       if (result['data'] != null) {
  //         if (attendance.value.clockInAt != null &&
  //             attendance.value.clockOutAt == null) {
  //           // isClockOut.value = true;
  //           // isClockInOutComplete.value = false;
  //         } else {
  //           // isClockOut.value = false;
  //         }
  //       }
  //     } else {
  //       Get.dialog(GetDialog(
  //         title: "Oopps",
  //         hasMessage: true,
  //         withCloseButton: true,
  //         hasCustomWidget: false,
  //         message: "Error: $result",
  //         type: "error",
  //         buttonNumber: 0,
  //       ));
  //       pageName.value = '/home';
  //       printError(info: 'Error Message getLatestLog: Invalid Request');
  //     }
  //   } catch (error) {
  //     Get.dialog(GetDialog(
  //       title: "Oopps",
  //       hasMessage: true,
  //       withCloseButton: true,
  //       hasCustomWidget: false,
  //       message: "Error: $error",
  //       type: "error",
  //       buttonNumber: 0,
  //     ));
  //     pageName.value = '/home';
  //     printError(info: 'Error Message getLatestLog: $error');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
