import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

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
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }
}
