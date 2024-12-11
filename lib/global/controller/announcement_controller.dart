import 'package:ems_v4/global/api.dart';
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
        })
        .catchError((error) {})
        .whenComplete(() {
          isLoading.value = false;
        });
  }
}
