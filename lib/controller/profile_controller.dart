import 'dart:convert';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';
import 'package:ems_v4/global/api.dart';

class ProfileController extends GetxController {
  final ApiCall apiCall = ApiCall();
  RxBool isLoading = false.obs;

  Future<void> updatePersonalInformation(
      String contactNumber, String email, String image) async {
    isLoading.value = true;

    try {
      var response = await apiCall.postRequest({
        'contact_number': contactNumber,
        'email': email,
        'image': image,
      }, '/otp-validition');
      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        await Get.dialog(
          barrierDismissible: false,
          GetDialog(
            type: 'success',
            title: 'Personal Information Updated',
            hasMessage: true,
            message: "You successfully updated your personal information.",
            buttonNumber: 1,
            hasCustomWidget: true,
            withCloseButton: false,
            okPress: () {
              Get.back();
            },
            okText: "Close",
            okButtonBGColor: bgPrimaryBlue,
          ),
        );
      } else {
        Get.dialog(
          GetDialog(
            title: "Opps!",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Error update information: ${result['message']}",
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
          message: "Error update information: $e !",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
