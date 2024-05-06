import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  ApiCall apiCall = ApiCall();
  RxList schedules = [].obs;
  final int routerKey = 3;

  Future getDTROnDate(DateTime? date) async {
    isLoading.value = true;
    apiCall
        .postRequest(
      apiUrl: "/attendance-records/get-attendance-info",
      data: {
        "attendance_date": date.toString().split(" ")[0],
      },
      catchError: (error) {},
    )
        .then((result) {
      if (result.containsKey("success") && result["success"] == true) {
        log(result["data"]["schedules"].toString());
        schedules.value = result["data"]["schedules"];
      }
    }).whenComplete(() => isLoading.value = false);
  }

  void resetSchedules() {
    schedules.value = [];
  }
}
