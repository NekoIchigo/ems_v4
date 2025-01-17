import 'dart:developer';

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

  RxBool isLoading = false.obs, isPaginateLoading = false.obs;
  RxString pageUrl = ''.obs;
  RxInt paginateLength = 1.obs;
  RxInt currentPage = 1.obs, totalAnnouncement = 1.obs;

  final ApiCall _apiCall = ApiCall();

  Future index(bool isInit) async {
    isLoading.value = true;
    today = DateTime(today.year, today.month, today.day);
    _apiCall
        .getRequest(
            apiUrl: "/mobile/announcements/index",
            parameters: {"page": currentPage})
        .then((response) async {
          final data = response["data"]["data"];
          totalAnnouncement.value = response["data"]["total"];
          paginateLength.value = response["data"]["last_page"];
          announcements.addAll(data);
          for (var announcement in announcements) {
            DateTime startDate = DateTime.parse(announcement['start_date']);
            DateTime endDate = DateTime.parse(announcement['end_date']);
            if ((startDate.isBefore(today) || startDate == today) &&
                (endDate.isAfter(today) || endDate == today)) {
              if (announcement['banner_path'] != null) {
                announcement['banner_path'] = await downloadAnnouncementImage(
                    announcement['banner_path']);
              }
              postedAnnouncements.add(announcement);
            }
          }
          if (postedAnnouncements.isNotEmpty && isInit) {
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

  Future downloadAnnouncementImage(path) async {
    try {
      final response = await _apiCall.getRequest(
        apiUrl: '/download',
        isBlob: true,
        parameters: {'path': path, 'offset': 0},
      );
      return response['path'];
    } catch (error) {
      print("s3_image: $error");
      return null;
    }
  }
}
