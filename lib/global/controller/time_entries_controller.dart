import 'dart:convert';
import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
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
      dynamic response;
      if (days == 0) {
        List<String> fromDate = startDate!.toString().split(" ");
        List<String> toDate = endDate!.toString().split(" ");
        response = await apiCall.getRequest(
            '/show-dtrs/$employeeId?days=$days&startDate=${fromDate[0]}&endDate=${toDate[0]}');
      } else {
        response =
            await apiCall.getRequest('/show-dtrs/$employeeId?days=$days');
      }

      var result = jsonDecode(response.body);
      log(result.toString());
      if (result['success']) {
        pageUrl.value = "${result['data']['first_page_url']}&days=$days";
        paginateLength.value = result['data']['last_page'];
        currentPage.value = result['data']['current_page'];

        final attendancesJson = result['data']['data'];
        attendances = RxList<AttendanceRecord>.from(attendancesJson
            .map((attendance) => AttendanceRecord.fromJson(attendance)));
      } else {
        Get.dialog(GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ));
      }
    } catch (error) {
      Get.dialog(GemsDialog(
        title: "Oops",
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
    if (currentPage.value < paginateLength.value) {
      isListLoading.value = true;
      try {
        dynamic response;
        if (currentDays == 0) {
          response = await apiCall.getRequest(
              '/show-dtrs/$empId?days=$currentDays&startDate=$currentStartDate&endDate=$currentEndDate&page=${currentPage.value}');
        } else {
          response = await apiCall.getRequest(
              '/show-dtrs/$empId?days=$currentDays&page=${currentPage.value}');
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
          Get.dialog(GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error: $result",
            type: "error",
            buttonNumber: 0,
          ));
        }
      } catch (e) {
        Get.dialog(GemsDialog(
          title: "Oops",
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

  Future getPreviousClockIn() async {
    isListLoading.value = true;
    try {
      var response =
          await apiCall.getRequest('/show-dtrs/$empId?days=1&page=1');
      var result = jsonDecode(response.body);

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
        Get.dialog(GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error: $result",
          type: "error",
          buttonNumber: 0,
        ));
      }
    } catch (e) {
      Get.dialog(GemsDialog(
        title: "Oops",
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
