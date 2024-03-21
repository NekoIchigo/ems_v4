import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeEntriesController extends GetxController {
  final ApiCall apiCall = ApiCall();
  RxString pageName = '/index'.obs;
  RxInt attendanceIndex = 0.obs;

  RxBool hasClose = false.obs,
      isLoading = false.obs,
      isListLoading = false.obs,
      hasPrevAttendance = false.obs;

  Rx<AttendanceRecord> prevAttendance = AttendanceRecord().obs;
  RxList<AttendanceRecord> attendances = [AttendanceRecord()].obs;
  RxString pageUrl = ''.obs;
  RxInt paginateLength = 1.obs;
  RxInt currentPage = 1.obs;

  int empId = 0;
  int currentDays = 0;
  dynamic currentStartDate;
  dynamic currentEndDate;

  Future getAttendanceList({
    required int employeeId,
    required int days,
    startDate,
    endDate,
  }) async {
    isLoading.value = true;
    empId = employeeId;
    currentDays = days;
    currentStartDate = startDate;
    currentEndDate = endDate;

    try {
      // ignore: prefer_typing_uninitialized_variables
      var result;
      if (days == 0) {
        List<String> fromDate = startDate!.toString().split(" ");
        List<String> toDate = endDate!.toString().split(" ");
        result = await apiCall.getRequest(
          apiUrl: '/show-dtrs',
          parameters: {
            'days': 1,
            'page': 1,
            'endDate': toDate[0],
            'startDate': fromDate[0],
          },
        );
      } else {
        result = await apiCall.getRequest(
          apiUrl: '/show-dtrs',
          parameters: {'days': 1, 'page': 1},
        );
      }

      log(result.toString());
      if (result['success']) {
        pageUrl.value = "${result['data']['first_page_url']}&days=$days";
        paginateLength.value = result['data']['last_page'];
        currentPage.value = result['data']['current_page'];

        final attendancesJson = result['data']['data'];
        attendances = RxList<AttendanceRecord>.from(attendancesJson
            .map((attendance) => AttendanceRecord.fromJson(attendance)));
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
            });
      }
    } catch (error) {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "Oops",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: "Error: $error",
              type: "error",
              buttonNumber: 0,
            );
          });
    } finally {
      isLoading.value = false;
    }
  }

  Future getPreviousClockIn() async {
    isListLoading.value = true;

    var result = await apiCall.getRequest(
      apiUrl: '/show-dtrs',
      parameters: {'days': 1, 'page': 1},
    );

    if (result['success']) {
      paginateLength.value = result['data']['last_page'];
      currentPage.value = result['data']['current_page'];

      final attendancesJson = result['data']['data'];
      attendances += RxList<AttendanceRecord>.from(
        attendancesJson.map(
          (attendance) => AttendanceRecord.fromJson(attendance),
        ),
      );
      if (attendances.length > 1) {
        hasPrevAttendance.value = true;
        prevAttendance.value = attendances[1];
      }
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

    isListLoading.value = false;
  }
}
