import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/announcement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  RxList announcements = [].obs;
  RxBool isLoading = false.obs;
  final ApiCall _apiCall = ApiCall();

  Future index() async {
    isLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/announcements/index")
        .then((response) {
          final data = response["data"];
          print(data);
          announcements.value = data;
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) {
              return const AnnouncementDialog();
            },
          );
        })
        .catchError((error) {})
        .whenComplete(() {
          isLoading.value = false;
        });
  }
}
