import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLuncher {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();

  Future<void> launchMap() async {
    // const String baseUrl = 'http://10.10.10.221:8000/mobile-map-view';
    const String baseUrl = "https://stg-ems.globalland.com.ph/mobile-map-view";

    String destinationLat =
        _authService.employee.value.employeeDetails.location.latitude;
    String destinationLong =
        _authService.employee.value.employeeDetails.location.longitude;

    String? originLat;
    String? originLong;

    if (_homeController.isClockOut.isTrue) {
      originLat = _homeController.attendance.value.clockedInLatitude;
      originLong = _homeController.attendance.value.clockedInLongitude;
    } else {
      originLat = _homeController.attendance.value.clockedOutLatitude;
      originLong = _homeController.attendance.value.clockedOutLongitude;
    }

    String latLong =
        "?originLat=$originLat&originLon=$originLong&destinationLat=$destinationLat&destinationLong=$destinationLong";

    if (!await launchUrl(Uri.parse("$baseUrl$latLong"))) {
      throw Exception('Could not launch $baseUrl$latLong');
    }
  }
}
