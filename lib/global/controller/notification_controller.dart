import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final ApiCall _apiCall = ApiCall();
  RxBool isLoading = false.obs;
  RxList notificationList = [].obs;

  Future<void> index() async {
    isLoading.value = true;
    _apiCall.getRequest(apiUrl: "/fetch-notifications", parameters: {
      "company_id": _authController.employee?.value.companyId,
      "employee_id": _authController.employee?.value.id,
    }).then((response) {
      if (response.containsKey('success') && response['success']) {
        notificationList.value = response['data'];
        notificationList.value = notificationList
            .where((item) => !item['message'].contains("You"))
            .toList();
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }
}
