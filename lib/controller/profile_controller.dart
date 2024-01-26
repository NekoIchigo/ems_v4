import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  RxBool isLoading = false.obs;

  Future<void> updateContacts(email, contactNumber) async {
    isLoading.value = true;

    try {
      var response = await apiCall.postRequest(
          {'email': email, 'contact_number': contactNumber},
          '/update-contact/${_authService.employee.value.employeeContact.id}');
      var result = jsonDecode(response.body);
      print(result);
      if (result.containsKey('success') && result['success']) {
        await Get.dialog(
          barrierDismissible: false,
          GetDialog(
            type: 'success',
            title: 'Profile Information Updated',
            hasMessage: false,
            message: "An OTP has been sent to verify your email address",
            buttonNumber: 1,
            hasCustomWidget: false,
            withCloseButton: false,
            okPress: () {
              Get.back();
            },
            okText: "Close",
            okButtonBGColor: gray,
          ),
        );
      } else {
        Get.dialog(
          const GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error Forgot Password: Something went wrong!",
            type: "error",
            buttonNumber: 0,
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        GetDialog(
          title: "Opps!",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Error Forgot Password: $e !",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
