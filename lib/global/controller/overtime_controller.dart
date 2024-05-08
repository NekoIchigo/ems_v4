import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OvertimeController extends GetxController {
  RxBool isLoading = false.obs, isSubmitting = false.obs;
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
}