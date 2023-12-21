import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/attendance.dart';
import 'package:ems_v4/views/widgets/dialog/ems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeEntriesController extends GetxController {
  final ApiCall apiCall = ApiCall();
  RxString pageName = '/index'.obs;
  RxInt attendanceIndex = 0.obs;

  RxBool hasClose = false.obs;
  RxBool isLoading = false.obs;
  late RxList<Attendance> attendances;

  Future getAttendanceList({
    required int employeeId,
    required BuildContext context,
    required int months,
    startDate,
    endDate,
  }) async {
    isLoading.value = true;
    try {
      dynamic response;
      if (months == 0) {
        response = await apiCall.getRequest(
            '/show-dtrs/$employeeId?months=$months&startDate=$startDate&endDat=$endDate');
      } else {
        response =
            await apiCall.getRequest('/show-dtrs/$employeeId?months=$months');
      }
      var result = jsonDecode(response.body);
      print("result time =  $result");
      if (result['success']) {
        final attendancesJson = result['data']['data'];
        attendances = RxList<Attendance>.from(attendancesJson
            .map((attendance) => Attendance.fromJson(attendance)));
        // print(attendances.length);
      } else {
        // if (!context.mounted) {
        //   return;
        // }
        await EMSDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ).show(context);
        // pageName.value = '/home';
      }
    } catch (error) {
      // if (!context.mounted) {
      //   return;
      // }
      await EMSDialog(
        title: "Opps!",
        hasMessage: true,
        withCloseButton: true,
        hasCustomWidget: false,
        message: "Error: $error",
        type: "error",
        buttonNumber: 0,
      ).show(context);
    } finally {
      isLoading.value = false;
    }
  }
}
