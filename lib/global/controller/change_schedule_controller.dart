import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/models/schedule.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeScheduleController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  RxBool isLoading = false.obs, isSubmitting = false.obs;
  RxList<Schedule> schedules = [Schedule(id: 0, name: "No Schedule")].obs;
  Rx<Schedule> selectedSchedule = Schedule(id: 0, name: "No Schedule").obs;
  final ApiCall _apiCall = ApiCall();

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  Future<void> sendRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
            apiUrl: "/save-change-schedule", data: data, catchError: () {})
        .then((result) {
      print(result);
      navigatorKey.currentContext!.push("/transaction_result", extra: {
        "result": result["success"],
        "message": result["message"],
        "path": "/change_schedule",
      });
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getScheduleByType(String type) async {
    isLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/schedules/schedule-by-type",
      parameters: {
        "schedule_type": type,
        "company_id": _authController.company.value.id,
      },
      catchError: () {},
    )
        .then((result) {
      print(result);

      schedules.value = result["data"]
          .map<Schedule>((schedule) =>
              Schedule(id: schedule['id'], name: schedule['name']))
          .toList();
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<void> getAllChangeSchedule() async {
    isLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/change-schedule", catchError: () {})
        .then((result) {
      final data = result["data"];
      log(data.toString());
      approvedList.value = data["approved"];
      pendingList.value = data["pending"];
      rejectedList.value = data["rejected"];
      cancelledList.value = data["cancelled"];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future fetchScheduleList(List<DateTime?> dates) async {
    print(dates);
    isLoading.value = true;
    var response = await _apiCall.getRequest(
      apiUrl: "/fetch-employee-schedule-list",
      parameters: {
        "company_id": _authController.company.value.id,
        "employee_id": _authController.employee?.value.id,
        "from": dates[0],
        "to": dates[1],
      },
      catchError: () {},
    );
    print(response);
    isLoading.value = false;
  }
}
