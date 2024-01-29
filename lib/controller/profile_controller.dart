import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:get/get.dart';
import 'package:ems_v4/global/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  late SharedPreferences _localStorage;

  final ApiCall apiCall = ApiCall();
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;

  Future<void> updatePersonalInformation(
      String contactNumber, String email) async {
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;
    var userData = jsonDecode(_localStorage.getString('user')!);
    String? image = profileImage.value != '' ? profileImage.value : null;
    try {
      var response = await apiCall.postRequest({
        'id': userData['id'],
        'contact_number': contactNumber,
        'email': email,
        'image': image,
      }, '/update-personal-info');
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

  String? convertToBase64(XFile? image) {
    if (image != null) {
      File file = File(image.path);
      List<int> imageBytes = file.readAsBytesSync();
      String base64String = base64Encode(Uint8List.fromList(imageBytes));
      // log(base64String);
      return base64String;
    }
    return null;
  }

  Future selectProfileImage() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    profileImage.value = convertToBase64(image) ?? '';
  }

  void setState(Null Function() param0) {}
}
