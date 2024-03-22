import 'dart:async';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/app_version_dialog.dart';
import 'package:ems_v4/views/widgets/dialog/maintenance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:store_version_checker/store_version_checker.dart';

class SettingsController extends GetxController {
  final ApiCall apiCall = ApiCall();
  final _checker = StoreVersionChecker();

  RxBool isMaintenance = false.obs,
      isLoading = false.obs,
      isSettingsOpen = false.obs,
      hasUpdate = false.obs;
  Rx<DateTime> currentTime = DateTime.now().obs;

  void updateTimeToRealTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = currentTime.value.add(const Duration(seconds: 1));
    });
  }

  Future getServerTime() async {
    isLoading.value = true;
    var result = await apiCall.getRequest(
      apiUrl: '/server-time',
      catchError: (error) => isLoading.value = false,
    );

    if (result.containsKey('success') && result['success']) {
      currentTime.value = DateTime.parse(result['data']['withTimeZone']);
    }

    isLoading.value = false;
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
        isLoading.value = true;
        var result = await apiCall.postRequest(
          data: {'version': value.currentVersion},
          apiUrl: '/check-maintenance',
          catchError: (error) => isLoading.value = false,
        );

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
        }

        isLoading.value = false;
      }
    });
  }

  Future checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Geolocator.openLocationSettings();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      navigatorKey.currentContext!.go('/no-permission');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        navigatorKey.currentContext!.go('/no-permission');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      navigatorKey.currentContext!.go('/no-permission');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}
