import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeRestdayController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
  final ApiCall _apiCall = ApiCall();

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  RxList<Map<String, dynamic>> days = [
    {"day": "Sun", "value": false, "name": "Sunday"},
    {"day": "Mon", "value": false, "name": "Monday"},
    {"day": "Tue", "value": false, "name": "Tuesday"},
    {"day": "Wed", "value": false, "name": "Wednesday"},
    {"day": "Thu", "value": false, "name": "Thursday"},
    {"day": "Fri", "value": false, "name": "Friday"},
    {"day": "Sat", "value": false, "name": "Saturday"},
  ].obs;

  Future<void> sendRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
            apiUrl: "/save-change-restday", data: data, catchError: () {})
        .then((result) {
      navigatorKey.currentContext!.push("/transaction_result", extra: {
        "result": result["success"],
        "message": result["message"],
        "path": "/change_restday",
      });
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getAllChangeRestday() async {
    isLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/change-restday", catchError: () {})
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
