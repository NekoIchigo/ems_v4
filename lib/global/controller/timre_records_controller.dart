import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:get/get.dart';

class TimeRecordsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList cutoffPeriods = [].obs;
  RxList attendanceMasters = [].obs;
  final AuthController _auth = Get.find<AuthController>();
  final ApiCall _apiCall = ApiCall();

  Future fetchCutoffPeriods() async {
    isLoading.value = true;
    _apiCall
        .getRequest(
            apiUrl: '/mobile/cutoff/index',
            parameters: {
              'company_id': _auth.company.value.id,
            },
            catchError: () {})
        .then((response) {
      print(response);
      if (response.containsKey('success') && response['success']) {
        cutoffPeriods.value = response['data'];
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future fetchAttendanceMasters(int cutoffPeriodId) async {
    isLoading.value = true;
    _apiCall
        .getRequest(
            apiUrl: '/mobile/cutoff/attendance/master',
            parameters: {
              'employee_id': _auth.employee?.value.id,
              'cutoff_period_id': cutoffPeriodId,
            },
            catchError: () {})
        .then((response) {
      print(response);
      if (response.containsKey('success') && response['success']) {
        attendanceMasters.value = response['data'];
      }
    }).whenComplete(() {});
  }
}
