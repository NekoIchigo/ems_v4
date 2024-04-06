import 'dart:async';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/app_version_dialog.dart';
import 'package:ems_v4/views/widgets/dialog/location_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_version_checker/store_version_checker.dart';

class SettingsController extends GetxController {
  late SharedPreferences _localStorage;
  final ApiCall apiCall = ApiCall();
  final _checker = StoreVersionChecker();

  RxString currentPath = ''.obs, appVersion = ''.obs;

  RxBool isMaintenance = false.obs,
      isLoading = false.obs,
      isSettingsOpen = false.obs,
      hasLocation = false.obs,
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
      appVersion.value = value.currentVersion;
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
            navigatorKey.currentContext!.go('/maintenance');
            // showDialog(
            //   context: navigatorKey.currentContext!,
            //   barrierDismissible: false,
            //   builder: (context) {
            //     return const MaintenanceDialog();
            //   },
            // );
          }
        }

        isLoading.value = false;
      }
    });
  }

  Future checkLocationPermission(String path) async {
    _localStorage = await SharedPreferences.getInstance();
    bool firstCheck = _localStorage.getBool('first_loc_check') ?? true;
    bool serviceEnabled;
    LocationPermission permission;

    // Geolocator.openLocationSettings();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      navigatorKey.currentContext!
          .go('/no-permission', extra: {'path': path, 'type': 'off'});
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      hasLocation.value = true;
      firstCheck = false;
      _localStorage.setBool('first_loc_check', false);
    }

    if (permission == LocationPermission.denied) {
      if (firstCheck) {
        List result = await showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return const LocationDisclosure();
          },
        );

        if (result[0]) {
          permission = await Geolocator.requestPermission();
        }

        hasLocation.value = true;
        firstCheck = false;
        _localStorage.setBool('first_loc_check', false);
      } else {
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          hasLocation.value = false;
          navigatorKey.currentContext!.go('/no-permission',
              extra: {'path': path, 'type': 'no_permission'});
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        hasLocation.value = false;
        navigatorKey.currentContext!.go('/no-permission',
            extra: {'path': path, 'type': 'no_permission'});
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
  }
}
