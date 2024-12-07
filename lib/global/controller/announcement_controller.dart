import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  RxList announcements = [].obs;
  final ApiCall _apiCall = ApiCall();

  Future index() async {
    _apiCall.getRequest(apiUrl: "apiUrl");
  }
}
