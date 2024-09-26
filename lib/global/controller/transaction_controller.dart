import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;
  ApiCall apiCall = ApiCall();
  RxList schedules = [].obs;
  RxString initialSchedule = "".obs;
  RxMap transactionData = {}.obs;
  RxString dtrRange = "00:00 to 00:00".obs,
      scheduleName = "Schedule name".obs,
      clockInAt = "00:00".obs,
      clockOutAt = "00:00".obs;
  final int routerKey = 3;

  Future getSingleSchedule(String? date) async {
    isLoading.value = true;
    apiCall.getRequest(apiUrl: "/fetch-employee-single-sched", parameters: {
      "employee_id": _auth.employee?.value.id,
      "selected_date": date,
      "company_id": _auth.employee?.value.companyId,
    }).then((result) {
      if (result.containsKey("success") && result["success"] == true) {
        final data = result["data"][0];
        scheduleName.value = data["schedule_description"];
        dtrRange.value = data["dtr_description"];
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future getDTROnDate(String? date) async {
    isLoading.value = true;
    apiCall
        .postRequest(
      apiUrl: "/mobile/attendance-records/get-attendance-info",
      data: {
        "attendance_date": date,
      },
      catchError: (error) {},
    )
        .then((result) {
      if (result.containsKey("success") && result["success"] == true) {
        schedules.value = result["data"]["schedules"];

        transactionData.value = result["data"];
        dtrRange.value = transactionData["dtr"];
        scheduleName.value = transactionData["schedules"][0]["name"] ??
            transactionData["schedules"][0]["sub_name"];
      }
    }).whenComplete(() => isLoading.value = false);
  }

  Future getDTRBySchedule(int scheduleId, String? date) async {
    isLoading.value = true;
    print(scheduleId);
    apiCall
        .getRequest(
      apiUrl: "/mobile/dtr/get-by-schedule",
      parameters: {
        "schedule_id": scheduleId,
        "attendance_date": date,
      },
      catchError: (error) {},
    )
        .then((result) {
      if (result.containsKey("success") && result["success"] == true) {
        print(result);
        final data = result['data'];
        dtrRange.value = data["dtr"];
        clockInAt.value = data["clock_in"];
        clockOutAt.value = data["clock_out"];
      }
    }).whenComplete(() => isLoading.value = false);
  }

  Future getDTROnDateRange(String? dateStart, String? dateEnd) async {
    isLoading.value = true;
    apiCall
        .postRequest(
      apiUrl: "/mobile/attendance-records/get-attendances-info-range",
      data: {
        "start_date": dateStart,
        "end_date": dateEnd,
      },
      catchError: () {},
    )
        .then((result) {
      schedules.value = result["data"]["schedules"];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  void resetData() {
    schedules.value = [];
    transactionData.value = {};
  }
}
