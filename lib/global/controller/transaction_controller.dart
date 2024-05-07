import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  ApiCall apiCall = ApiCall();
  RxList schedules = [].obs;
  RxMap transactionData = {}.obs;
  RxString dtrRange = "00:00 to 00:00".obs, scheduleName = "Schedule name".obs;
  final int routerKey = 3;

  Future getDTROnDate(DateTime? date) async {
    isLoading.value = true;
    apiCall
        .postRequest(
      apiUrl: "/mobile/attendance-records/get-attendance-info",
      data: {
        "attendance_date": date.toString().split(" ")[0],
      },
      catchError: (error) {},
    )
        .then((result) {
      if (result.containsKey("success") && result["success"] == true) {
        schedules.value = result["data"]["schedules"];
        transactionData.value = result["data"];
        dtrRange.value = transactionData["dtr"];
        scheduleName.value = transactionData["schedules"][0]["name"];
      }
    }).whenComplete(() => isLoading.value = false);
  }

  void resetData() {
    schedules.value = [];
    transactionData.value = {};
  }
}
