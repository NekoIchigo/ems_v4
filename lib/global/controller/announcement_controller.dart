import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/announcement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  RxList announcements = [].obs;
  RxList postedAnnouncements = [].obs;
  int maxAnnouncementsToDisplay = 3;
  DateTime today = DateTime.now();

  RxBool isLoading = false.obs;
  final ApiCall _apiCall = ApiCall();

  Future index() async {
    isLoading.value = true;
    today = DateTime(today.year, today.month, today.day);
    _apiCall
        .getRequest(apiUrl: "/mobile/announcements/index")
        .then((response) {
          final data = response["data"];
          print(data);
          announcements.value = data;
          for (var announcement in announcements) {
            DateTime startDate = DateTime.parse(announcement['start_date']);
            DateTime endDate = DateTime.parse(announcement['end_date']);
            if ((startDate.isBefore(today) || startDate == today) &&
                (endDate.isAfter(today) || endDate == today)) {
              postedAnnouncements.add(announcement);
            }
          }
          if (postedAnnouncements.isNotEmpty) {
            showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) {
                return AnnouncementDialog(items: postedAnnouncements);
              },
            );
          }
        })
        .catchError((error) {})
        .whenComplete(() {
          isLoading.value = false;
        });
  }
}
