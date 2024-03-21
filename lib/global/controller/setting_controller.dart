import 'dart:async';
import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/app_version_dialog.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/dialog/maintenance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_version_checker/store_version_checker.dart';

class SettingsController extends GetxController {
  final ApiCall apiCall = ApiCall();
  final _checker = StoreVersionChecker();

  RxBool isMaintenance = false.obs,
      isLoading = false.obs,
      hasUpdate = false.obs;
  Rx<DateTime> currentTime = DateTime.now().obs;

  void updateTimeToRealTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = currentTime.value.add(const Duration(seconds: 1));
    });
  }

  Future getServerTime() async {
    try {
      isLoading.value = true;
      var response = await apiCall.getRequest('/server-time');
      var result = jsonDecode(response.body);
      if (result.containsKey('success') && result['success']) {
        currentTime.value = DateTime.parse(result['data']['withTimeZone']);
      }
    } catch (error) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "Oops",
            hasMessage: true,
            withCloseButton: true,
            hasCustomWidget: false,
            message: "Something went wrong! \n Error Code: $error",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future checkAppVersionMaintenance() async {
    _checker.checkUpdate().then((value) async {
      if (value.canUpdate) {
        isMaintenance.value = true;
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AppVersionDialog(
              url: value.appURL,
              version: value.newVersion,
            );
          },
        );
      } else {
        try {
          isLoading.value = true;
          var response = await apiCall.postRequest(
              {'version': value.currentVersion}, '/check-maintenance');
          var result = jsonDecode(response.body);

          if (result.containsKey('success') && result['success']) {
            isMaintenance.value =
                result['data']['under_maintenance'] == 1 ? true : false;
            if (isMaintenance.isTrue) {
              showDialog(
                context: navigatorKey.currentContext!,
                barrierDismissible: false,
                builder: (context) {
                  return const MaintenanceDialog();
                },
              );
            }
          } else {}
        } catch (error) {
          if (error.toString().contains('html')) {
            isMaintenance.value = true;
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return const MaintenanceDialog();
              },
            );
          } else {
            isMaintenance.value = true;
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return GemsDialog(
                  title: "Oops",
                  hasMessage: true,
                  withCloseButton: true,
                  hasCustomWidget: false,
                  message: "Something went wrong! \n Error Code: $error",
                  type: "error",
                  buttonNumber: 0,
                );
              },
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    });
  }
}
