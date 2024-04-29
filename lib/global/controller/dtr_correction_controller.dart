import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class DTRCorrectionController extends GetxController {
  RxBool isLoading = false.obs;
  ApiCall apiCall = ApiCall();
  RxList dtrModels = [].obs;
  // ! properly analize how to get the dtr of each schedule.
  // ! it must be in attendance masters to get the record.
  Future getDTROnDate(DateTime? date) async {
    isLoading.value = true;
    print(date.toString().split(" ")[0]);
    var result = await apiCall.postRequest(
      apiUrl: "/dtr-correction/get-attendance-info",
      data: {
        "attendance_date": date.toString().split(" ")[0],
      },
      catchError: (error) {},
    );

    if (result.containsKey("success") && result["success"] == true) {
      log(result["data"]["schedules"].toString());
      dtrModels = result["data"];
    }
    isLoading.value = false;
  }
}
