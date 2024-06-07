import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ChangeRestdayController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
  final ApiCall _apiCall = ApiCall();
  RxMap<String, dynamic> errors = {"errors": 0}.obs;

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  // RxList<ValueItem> days = [
  // const ValueItem(label: "Sunday", value: "Sunday"),
  // const ValueItem(label: "Monday", value: "Monday"),
  // const ValueItem(label: "Tuesday", value: "Tuesday"),
  // const ValueItem(label: "Wednesday", value: "Wednesday"),
  // const ValueItem(label: "Thursday", value: "Thursday"),
  // const ValueItem(label: "Friday", value: "Friday"),
  // const ValueItem(label: "Saturday", value: "Saturday"),
  // ].obs;

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
}
