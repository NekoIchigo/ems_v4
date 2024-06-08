import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeRestdayController extends GetxController {
  RxBool isLoading = false.obs,
      isSubmitting = false.obs,
      isLogsLoading = false.obs;
  final ApiCall _apiCall = ApiCall();
  RxMap<String, dynamic> errors = {"errors": 0}.obs;
  Rx<TransactionLogs> selectedTransactionLogs = TransactionLogs().obs;
  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  Future<void> sendRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
            apiUrl: "/save-change-restday", data: data, catchError: () {})
        .then((result) {
      if (result.containsKey('success') && result['success']) {
        navigatorKey.currentContext!.push("/transaction_result", extra: {
          "result": result["success"],
          "message": result["message"],
          "path": "/change_restday",
        });
      } else {
        errors.value = result;
      }
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
      approvedList.value = data["approved"];
      pendingList.value = data["pending"];
      rejectedList.value = data["rejected"];
      cancelledList.value = data["cancelled"];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future getLogs(int id) async {
    isLogsLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/change-restday-request/$id/log",
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
}
