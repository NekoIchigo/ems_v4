import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/models/employee_leave.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/router/router.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LeaveController extends GetxController {
  RxBool isLoading = false.obs,
      isSubmitting = false.obs,
      isLogsLoading = false.obs;
  Rx<TransactionLogs> selectedTransactionLogs = TransactionLogs().obs;
  final AuthController _auth = Get.find<AuthController>();
  RxMap<String, dynamic> errors = {"errors": 0}.obs;
  RxList<EmployeeLeave> leaves = [
    EmployeeLeave(id: 0, name: "-- Select Leave --"),
  ].obs;
  final ApiCall _apiCall = ApiCall();
  Rx<EmployeeLeave> selectedLeave = EmployeeLeave(id: 0).obs;

  RxList approvedList = [].obs,
      pendingList = [].obs,
      rejectedList = [].obs,
      cancelledList = [].obs;

  Future<void> submitRequest(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    _apiCall
        .postRequest(
      apiUrl: "/save-leave-request",
      data: data,
      catchError: () {},
    )
        .then((result) {
      if (result.containsKey('success') && result['success']) {
        getAllLeave(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push(
          "/transaction_result",
          extra: {
            "result": result["success"] ?? false,
            "message": result["message"],
            "path": "/leave",
          },
        );
      } else {
        errors.value = result;
      }
    }).whenComplete(() {
      isSubmitting.value = false;
    });
  }

  Future<void> getAllLeave(int days, startDate, endDate) async {
    isLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/leave",
      parameters: {
        "days": days,
        "startDate": startDate,
        "emdDate": endDate,
      },
      catchError: () {},
    )
        .then((result) {
      final data = result["data"];
      approvedList.value = data["approved"]['data'];
      pendingList.value = data["pending"]['data'];
      rejectedList.value = data["rejected"]['data'];
      cancelledList.value = data["cancelled"]['data'];
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<void> getAvailableLeave(int? leaveId) async {
    isLoading.value = true;
    leaves.value = [];
    var result = await _apiCall.getRequest(
      apiUrl: "/employee-leave/${_auth.employee?.value.id}",
      catchError: () {},
    );
    List data = result['data'];

    for (var empLeave in data) {
      double credits = double.parse(empLeave['credits']);
      leaves.add(
        EmployeeLeave(
          id: empLeave['id'],
          employeeCredits: credits,
          name: empLeave['leave']['name'],
          leaveId: empLeave['leave']['id'],
          employeeId: empLeave['employee_id'],
        ),
      );
    }
    if (leaves.length > 1 && leaveId != null) {
      EmployeeLeave? item = leaves
          .where((empLeave) {
            return empLeave.leaveId == leaveId;
          })
          .toList()
          .firstOrNull;
      if (item != null) selectedLeave.value = item;
    }
    isLoading.value = false;
  }

  Future getLogs(int id) async {
    isLogsLoading.value = true;
    _apiCall
        .getRequest(
      apiUrl: "/mobile/leave-request/$id/log",
      catchError: () {},
    )
        .then((response) {
      selectedTransactionLogs.value = TransactionLogs(
        requestData: response['data'],
        approvalHistory: response['approval_history'],
      );
    }).whenComplete(() {
      isLogsLoading.value = false;
    });
  }

  Future cancelRequest(int id, BuildContext context) async {
    if (id != 0) {
      isLoading.value = true;
      _apiCall
          .postRequest(
        apiUrl: '/leave-request/cancel',
        data: {"id": id},
        catchError: () {},
      )
          .then((result) {
        Navigator.of(context).pop();
        getAllLeave(30, DateTime.now(), DateTime.now());
        navigatorKey.currentContext!.push(
          "/transaction_result",
          extra: {
            "result": result["success"] ?? false,
            "message": result["message"],
            "path": "/leave",
          },
        );
      }).whenComplete(() {
        isLoading.value = false;
      });
    }
  }
}
