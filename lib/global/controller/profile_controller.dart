import 'dart:convert';
import 'dart:io';

import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:get/get.dart';
import 'package:ems_v4/global/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final AuthController authService = Get.find<AuthController>();
  final ImagePicker _imagePicker = ImagePicker();
  late SharedPreferences _localStorage;

  final ApiCall apiCall = ApiCall();
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;

  Future<void> updatePersonalInformation() async {
    _localStorage = await SharedPreferences.getInstance();
    isLoading.value = true;
    var userData = jsonDecode(_localStorage.getString('user')!);
    String? image = profileImage.value != '' ? profileImage.value : null;

    var result = await apiCall.postRequest(data: {
      'id': userData['id'],
      'image': image,
    }, apiUrl: '/update-personal-info');

    if (result.containsKey('success') && result['success']) {
      if (profileImage.value != '') {
        authService.employee!.value.profileBase64 = profileImage.value;
      }
      await showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return const GemsDialog(
              type: 'success',
              title: 'Success',
              hasMessage: true,
              message: "You successfully updated your personal information.",
              buttonNumber: 0,
              hasCustomWidget: false,
              withCloseButton: true,
              okButtonBGColor: bgPrimaryBlue,
            );
          });
    } else {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return GemsDialog(
              title: "Oops",
              hasMessage: true,
              withCloseButton: true,
              hasCustomWidget: false,
              message: "Error update information: ${result['message']}",
              type: "error",
              buttonNumber: 0,
            );
          });
    }

    isLoading.value = false;
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
    if (image != null) {
      updatePersonalInformation();
    }
  }

  void setState(Null Function() param0) {}
}
