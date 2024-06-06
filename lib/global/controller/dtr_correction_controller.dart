import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrectionController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
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
        getAllDTR();
        navigatorKey.currentContext!.push(
          "/transaction_result",
          extra: {
            "result": result["success"] ?? false,
            "message": result["message"],
            "path": "/dtr_correction",
          },
        );
      } else {
        errors.value = result;
      }
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
      approvedList.value = data["approved"];
      pendingList.value = data["pending"];
      rejectedList.value = data["rejected"];
      cancelledList.value = data["cancelled"];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }
}
