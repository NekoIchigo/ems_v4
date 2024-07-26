import 'dart:developer';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthController _authService = Get.find<AuthController>();

  Future<void> launchMap(
      {AttendanceRecord? attendanceRecord,
      bool isclockin = false,
      String message = ""}) async {
    // const String baseUrl = 'http://10.10.10.221:8000/mobile-map-view';
    const String baseUrl = "${globalBaseUrl}mobile-map-view";

    String destinationLat =
        _authService.employee!.value.employeeDetails.location.latitude;
    String destinationLong =
        _authService.employee!.value.employeeDetails.location.longitude;

    String? originLat;
    String? originLong;
    if (attendanceRecord != null) {
      if (isclockin) {
        originLat = attendanceRecord.clockedInLatitude;
        originLong = attendanceRecord.clockedInLongitude;
      } else {
        originLat = attendanceRecord.clockedOutLatitude;
        originLong = attendanceRecord.clockedOutLongitude;
      }
    } else if (_homeController.isClockOut.isFalse) {
      originLat = _homeController.attendance.value.clockedInLatitude;
      originLong = _homeController.attendance.value.clockedInLongitude;
    } else {
      originLat = _homeController.attendance.value.clockedOutLatitude;
      originLong = _homeController.attendance.value.clockedOutLongitude;
    }

    log("destinationLat=$destinationLat, destinationLong=$destinationLong, originlat=$originLat, originlong=$originLong");
    String latLong =
        "?originLat=$originLat&originLong=$originLong&destinationLat=$destinationLat&destinationLong=$destinationLong&message=$message";

    if (!await launchUrl(Uri.parse("$baseUrl$latLong"))) {
      throw Exception('Could not launch $baseUrl$latLong');
    }
  }
}
