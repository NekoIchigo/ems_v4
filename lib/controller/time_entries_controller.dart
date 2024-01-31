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
  RxList<AttendanceRecord> attendances = [AttendanceRecord()].obs;

  Future getAttendanceList({
    required int employeeId,
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
      if (result['success']) {
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
}
