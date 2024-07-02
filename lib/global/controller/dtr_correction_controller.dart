import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrectionController extends GetxController {
  RxBool isLoading = false.obs,
      isSubmitting = false.obs,
      isLogsLoading = false.obs;
  Rx<TransactionLogs> selectedTransactionLogs = TransactionLogs().obs;
  RxMap<String, dynamic> errors = {"errors": 0}.obs;
  final ApiCall _apiCall = ApiCall();

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  Future<void> submitRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
      apiUrl: "/save-dtr",
      data: data,
      catchError: () {},
    )
        .then((result) {
      if (result.containsKey('success') && result['success']) {
        getAllDTR(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push(
          "/transaction_result",
          extra: {
            "result": result["success"] ?? false,
            "message": result["message"],
            "path": "/dtr_correction",
          },
        );
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

  Future<void> getAllDTR(int days, startDate, endDate) async {
    isLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/dtr-correction",
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

  Future getLogs(int id) async {
    isLogsLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/dtr-request/$id/log",
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
        apiUrl: '/dtr-request/cancel',
        data: {"id": id},
        catchError: () {},
      )
          .then((response) {
        Navigator.of(context).pop();
        getAllDTR(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push(
          "/transaction_result",
          extra: {
            "result": response["success"] ?? false,
            "message": response["message"],
            "path": "/dtr_correction",
          },
        );
      }).whenComplete(() {
        isLoading.value = false;
      });
    }
  }
}
