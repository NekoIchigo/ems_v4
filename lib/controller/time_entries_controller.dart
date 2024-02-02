import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';

class TimeEntriesController extends GetxController {
  final ApiCall apiCall = ApiCall();
  RxString pageName = '/index'.obs;
  RxInt attendanceIndex = 0.obs;

  RxBool hasClose = false.obs;
  RxBool isLoading = false.obs;
  RxBool isListLoading = false.obs;

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
      dynamic response;
      if (days == 0) {
        response = await apiCall.getRequest(
            '/show-dtrs/$employeeId?days=$days&startDate=$startDate&endDat=$endDate');
      } else {
        response =
            await apiCall.getRequest('/show-dtrs/$employeeId?days=$days');
      }

      var result = jsonDecode(response.body);

      if (result['success']) {
        pageUrl.value = "${result['data']['first_page_url']}&days=$days";
        paginateLength.value = result['data']['last_page'];
        currentPage.value = result['data']['current_page'];

        final attendancesJson = result['data']['data'];
        attendances = RxList<AttendanceRecord>.from(attendancesJson
            .map((attendance) => AttendanceRecord.fromJson(attendance)));
        // print(attendances.length);
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
    } finally {
      isLoading.value = false;
    }
  }

  Future getNextListPage() async {
    if (currentPage.value <= paginateLength.value) {
      isListLoading.value = true;
      try {
        dynamic response;
        if (currentDays == 0) {
          response = await apiCall.getRequest(
              '/show-dtrs/$empId?days=$currentDays&startDate=$currentStartDate&endDat=$currentEndDate');
        } else {
          response =
              await apiCall.getRequest('/show-dtrs/$empId?days=$currentDays');
        }
        var result = jsonDecode(response.body);

        if (result['success']) {
          pageUrl.value =
              "${result['data']['first_page_url']}&days=$currentDays";
          paginateLength.value = result['data']['last_page'];
          currentPage.value = result['data']['current_page'];

          final attendancesJson = result['data']['data'];
          attendances += RxList<AttendanceRecord>.from(attendancesJson
              .map((attendance) => AttendanceRecord.fromJson(attendance)));
          // print(attendances.length);
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
      } catch (e) {
        Get.dialog(GetDialog(
          title: "Oopps",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $e",
          type: "error",
          buttonNumber: 0,
        ));
      } finally {
        isListLoading.value = false;
      }
    }
  }
}
