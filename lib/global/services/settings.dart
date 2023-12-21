import 'dart:async';
import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends GetxService {
  final ApiCall apiCall = ApiCall();

  late SharedPreferences localStorage;
  RxString currentTimeString = ''.obs;
  late Rx<DateTime> currentTime;
  RxBool isLoading = false.obs;

  Future<Settings> init() async {
    await getServerTime();
    getGreeting();

    // Start a timer to update the time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateCurrentTime();
    });

    return this;
  }

 void updateCurrentTime() {
    currentTime.value = currentTime.value.add(Duration(seconds: 1));
  }

  Future getServerTime() async {
    try {
      isLoading.value = true;
      var response = await apiCall.getRequest('/server-time');
      var result = jsonDecode(response.body);
      if (result['success']) {
        currentTimeString.value = result['data']['withTimeZone'];
        currentTime = DateTime.parse(currentTimeString.value).obs;
      }

      isLoading.value = false;
    } catch (error) {
      printError(info: error.toString());
    }
  }

  String getGreeting() {
    // final currentTime = DateTime.now();
    final hour = currentTime.value.hour;

    if (hour >= 0 && hour < 12) {
      return 'Good morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }
}
