import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OvertimeController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;
  final ApiCall _apiCall = ApiCall();

  Future<void> submitRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
      apiUrl: "/save-overtime",
      data: data,
      catchError: () {},
    )
        .then((result) {
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

  Future<void> getAllOvertime() async {
    isLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/overtime", catchError: () {})
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
