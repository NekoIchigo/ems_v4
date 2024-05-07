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
      hasUpdate = false.obs,
      isFirstCheck = true.obs;
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
            return PopScope(
              canPop: false,
              child: AppVersionDialog(
                url: value.appURL,
                version: value.newVersion,
              ),
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

  Future oldCheckLocationPermission(String path) async {
    _localStorage = await SharedPreferences.getInstance();

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
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      hasLocation.value = true;
      isFirstCheck.value = false;
      _localStorage.setBool('first_loc_check', false);
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (isFirstCheck.value) {
          List result = await showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return const LocationDisclosure();
            },
          );

          if (result[0]) {
            Geolocator.openAppSettings();
          } else {
            permission = await Geolocator.requestPermission();
          }
        } else if (permission == LocationPermission.deniedForever) {
          hasLocation.value = false;
          navigatorKey.currentContext!.go('/no-permission',
              extra: {'path': path, 'type': 'no_permission'});
        }
      }

      hasLocation.value = true;
      isFirstCheck.value = false;
      _localStorage.setBool('first_loc_check', false);
    }
  }

  Future checkFirstLogin() async {
    _localStorage = await SharedPreferences.getInstance();
    isFirstCheck.value = _localStorage.getBool("first_loc_check") ?? true;

    if (isFirstCheck.isTrue) {
      isFirstCheck.value = false;
      _localStorage.setBool('first_loc_check', false);
      navigatorKey.currentContext!.go("/first_location");
    }
  }

  Future checkLocationService(String path) async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      navigatorKey.currentContext!
          .go('/no-permission', extra: {'path': path, 'type': 'off'});
    }
  }

  Future checkLocationPermission(String path) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      hasLocation.value = false;
      navigatorKey.currentContext!
          .go('/no-permission', extra: {'path': path, 'type': 'no_permission'});
    }
  }
}
