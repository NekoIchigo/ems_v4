import 'dart:async';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NotificationController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final LeaveController _leaveController = Get.find<LeaveController>();
  final ChangeScheduleController _changeSchedule =
      Get.find<ChangeScheduleController>();
  final OvertimeController _overtime = Get.find<OvertimeController>();
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();
  final ChangeRestdayController _changeRestday =
      Get.find<ChangeRestdayController>();
  final ApiCall _apiCall = ApiCall();
  RxBool isLoading = false.obs,
      isTransactionLoading = false.obs,
      isPaginateLoading = false.obs,
      showNotificationBadge = false.obs;
  RxList notificationList = [].obs;
  RxInt currentPage = 1.obs, paginateLength = 1.obs;

  Future<void> index() async {
    isLoading.value = true;
    _apiCall.getRequest(apiUrl: "/fetch-notifications-chat", parameters: {
      "company_id": _authController.employee?.value.companyId,
      "employee_id": _authController.employee?.value.id,
    }).then((response) {
      if (response.containsKey('success') && response['success']) {
        notificationList.value = response['data']['data'];
        notificationList.value = notificationList
            .where((item) => !item['message'].contains("You"))
            .toList();
        paginateLength.value = response['data']['last_page'];
        currentPage.value = response['data']['current_page'];
        showNotificationBadge.value = notificationList.isNotEmpty;
      }
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  Future<void> nextPageNotification() async {
    if (currentPage.value < paginateLength.value) {
      currentPage.value += 1;
    } else {
      return;
    }
    isPaginateLoading.value = true;
    _apiCall.getRequest(apiUrl: "/fetch-notifications-chat", parameters: {
      "company_id": _authController.employee?.value.companyId,
      "employee_id": _authController.employee?.value.id,
      "page": currentPage.value,
    }).then((response) {
      if (response.containsKey('success') && response['success']) {
        List newNotifications = response['data']['data'];
        newNotifications = newNotifications
            .where((item) => !item['message'].contains("You"))
            .toList();

        notificationList += newNotifications;
        paginateLength.value = response['data']['last_page'];
        currentPage.value = response['data']['current_page'];
        showNotificationBadge.value = notificationList.isNotEmpty;
      }
    }).whenComplete(() {
      isPaginateLoading.value = false;
    });
  }

  Future showOvertime(int parentId, BuildContext context) async {
    isTransactionLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/overtime/$parentId")
        .then((response) async {
      if (response.containsKey("success") && response["success"]) {
        final data = response["data"];
        final transactionItem = TransactionItem(
          id: data['id'],
          title: "",
          dateCreated: "",
          subtitle: "",
          status: data['status'],
          type: "",
          data: data,
        );
        await _overtime.getLogs(parentId);
        _overtime.transactionData = transactionItem.toMap().obs;
        context.push('/overtime_form', extra: transactionItem.toMap());
      }
    }).whenComplete(() => isTransactionLoading.value = false);
  }

  Future showChangeSchedule(int parentId, BuildContext context) async {
    isTransactionLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/change-schedule/$parentId")
        .then((response) async {
      if (response.containsKey("success") && response["success"]) {
        final data = response["data"];
        final transactionItem = TransactionItem(
          id: data['id'],
          title: "",
          dateCreated: "",
          subtitle: "",
          status: data['status'],
          type: "",
          data: data,
        );
        await _changeSchedule.getLogs(parentId);
        _changeSchedule.transactionData = transactionItem.toMap().obs;
        context.push('/change_schedule_form', extra: transactionItem.toMap());
      }
    }).whenComplete(() => isTransactionLoading.value = false);
  }

  Future showLeaveRequest(int parentId, BuildContext context) async {
    isTransactionLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/leave/$parentId")
        .then((response) async {
      if (response.containsKey("success") && response["success"]) {
        final data = response["data"];
        final transactionItem = TransactionItem(
          id: data['id'],
          title: "",
          dateCreated: "",
          subtitle: "",
          status: data['status'],
          type: "",
          data: data,
        );
        await _leaveController.getLogs(parentId);
        _leaveController.transactionData = transactionItem.toMap().obs;
        context.push('/leave_form', extra: transactionItem.toMap());
      }
    }).whenComplete(() => isTransactionLoading.value = false);
  }

  Future showDTRRequest(int parentId, BuildContext context) async {
    isTransactionLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/dtr-correction/$parentId")
        .then((response) async {
      if (response.containsKey("success") && response["success"]) {
        final data = response["data"];
        final transactionItem = TransactionItem(
          id: data['id'],
          title: "",
          dateCreated: "",
          subtitle: "",
          status: data['status'],
          type: "",
          data: data,
        );
        await _dtrCorrection.getLogs(parentId);
        _dtrCorrection.transactionData = transactionItem.toMap().obs;
        context.push('/dtr_correction_form', extra: transactionItem.toMap());
      }
    }).whenComplete(() => isTransactionLoading.value = false);
  }

  Future showChangeRestday(int parentId, BuildContext context) async {
    isTransactionLoading.value = true;
    _apiCall
        .getRequest(apiUrl: "/mobile/change-restday/$parentId")
        .then((response) async {
      if (response.containsKey("success") && response["success"]) {
        final data = response["data"];
        final transactionItem = TransactionItem(
          id: data['id'],
          title: "",
          dateCreated: "",
          subtitle: "",
          status: data['status'],
          type: "",
          data: data,
        );
        await _changeRestday.getLogs(parentId);
        _changeRestday.transactionData = transactionItem.toMap().obs;
        context.push('/change_restday_form', extra: transactionItem.toMap());
      }
    }).whenComplete(() => isTransactionLoading.value = false);
  }
}
