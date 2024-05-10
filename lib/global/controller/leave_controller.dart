import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LeaveController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
  RxList leaves = [].obs;
  final ApiCall _apiCall = ApiCall();

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  Future<void> submitRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;

    _apiCall
        .postRequest(
      apiUrl: "/save-leave-request",
      data: data,
      catchError: () {},
    )
        .then((result) {
      print(result);
      navigatorKey.currentContext!.push(
        "/transaction_result",
        extra: {
          "result": result["success"] ?? false,
          "message": result["message"],
          "path": "/overtime",
        },
      );
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getLeaveCredit() async {
    isLoading.value = true;
    _apiCall.getRequest(apiUrl: "/mobile", catchError: () {}).then((result) {
      final data = result["data"];
      log(data.toString());
      approvedList.value = data["approved"];
      pendingList.value = data["pending"];
      rejectedList.value = data["rejected"];
      cancelledList.value = data["cancelled"];
    }).whenComplete(() => isLoading.value = true);
  }
}
