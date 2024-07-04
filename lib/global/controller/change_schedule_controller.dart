import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/models/schedule.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeScheduleController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  RxBool isLoading = false.obs,
      isSubmitting = false.obs,
      isLogsLoading = false.obs;
  Rx<TransactionLogs> selectedTransactionLogs = TransactionLogs().obs;

  RxList<Schedule> schedules = [Schedule(id: 0, name: "No Schedule")].obs;
  Rx<Schedule> selectedSchedule = Schedule(id: 0, name: "No Schedule").obs;
  final ApiCall _apiCall = ApiCall();
  RxMap<String, dynamic> errors = {"errors": 0}.obs,
      transactionData = {"id": "0"}.obs;

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
      if (result.containsKey('success') && result['success']) {
        getAllChangeSchedule(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push("/transaction_result", extra: {
          "result": result["success"],
          "message": result["message"],
          "path": "/change_schedule",
        });
      } else {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "Oops!",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: result['message'],
              type: "error",
              buttonNumber: 0,
            );
          },
        );
      }
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getScheduleByType(String type, int? newScheduleId) async {
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
      if (result.containsKey('success') && result['success']) {
        getAllChangeSchedule(30, DateTime.now(), DateTime.now());
        schedules.value = result["data"]
            .map<Schedule>((schedule) =>
                Schedule(id: schedule['id'], name: schedule['name']))
            .toList();
        if (newScheduleId != null) {
          Schedule? item = schedules
              .where((schedule) {
                return schedule.id == newScheduleId;
              })
              .toList()
              .firstOrNull;
          if (item != null) selectedSchedule.value = item;
        }
      } else {
        errors.value = result;
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<void> getAllChangeSchedule(int days, startDate, endDate) async {
    isLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/change-schedule",
      parameters: {
        "days": days,
        "startDate": startDate,
        "emdDate": endDate,
      },
      catchError: () {},
    )
        .then((result) {
      final data = result["data"];
      approvedList.value = data["approved"]['data'];
      pendingList.value = data["pending"]['data'];
      rejectedList.value = data["rejected"]['data'];
      cancelledList.value = data["cancelled"]['data'];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future fetchScheduleList(List<DateTime?> dates) async {
    await _apiCall.getRequest(
      apiUrl: "/fetch-employee-schedule-list",
      parameters: {
        "company_id": _authController.company.value.id,
        "employee_id": _authController.employee?.value.id,
        "from": dates[0],
        "to": dates[1],
      },
      catchError: () {},
    );
    isLoading.value = false;
  }

  Future getLogs(int id) async {
    isLogsLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/change-schedule-request/$id/log",
      catchError: () {},
    )
        .then((response) {
      selectedTransactionLogs.value = TransactionLogs(
        requestData: response['data'],
        approvalHistory: response['approval_history'],
      );
    }).whenComplete(() {
      isLogsLoading.value = false;
    });
  }

  Future cancelRequest(int id, BuildContext context) async {
    if (id != 0) {
      isLoading.value = true;
      _apiCall
          .postRequest(
        apiUrl: '/change-schedule/cancel',
        data: {"id": id},
        catchError: () {},
      )
          .then((result) {
        Navigator.of(context).pop();
        getAllChangeSchedule(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push("/transaction_result", extra: {
          "result": result["success"],
          "message": result["message"],
          "path": "/change_schedule",
        });
      }).whenComplete(() {
        isLoading.value = false;
      });
    }
  }

  Future updateRequestForm(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
      apiUrl: "/change-schedule/update",
      data: data,
      catchError: () {},
    )
        .then((result) {
      getAllChangeSchedule(30, DateTime.now(), DateTime.now());
      navigatorKey.currentContext!.push(
        "/transaction_result",
        extra: {
          "result": result["success"] ?? false,
          "message": result["message"],
          "path": "/change_schedule",
        },
      );
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }
}
