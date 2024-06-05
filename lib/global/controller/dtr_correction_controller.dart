import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrectionController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
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
      navigatorKey.currentContext!.push(
        "/transaction_result",
        extra: {
          "result": result["success"] ?? false,
          "message": result["message"],
          "path": "/dtr_correction",
        },
      );
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getAllDTR() async {
    isLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/dtr-correction",
      catchError: () {},
    )
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
}