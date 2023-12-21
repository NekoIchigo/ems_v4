import 'dart:convert';
import 'dart:developer';

import 'package:ems_v4/global/api.dart';
import 'package:get/get.dart';

class Settings extends GetxService {
  final ApiCall apiCall = ApiCall();

  Future<Settings> init() async {
    getServerTime();
    return this;
  }

  Future getServerTime() async {
    var response = await apiCall.getRequest('/server-time');

    var result = jsonDecode(response.body);
    print(result);
  }
}
