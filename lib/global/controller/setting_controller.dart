import 'dart:async';
import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_version_checker/store_version_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final ApiCall apiCall = ApiCall();
  final _checker = StoreVersionChecker();

  RxBool isMaintenance = false.obs,
      isLoading = false.obs,
      hasUpdate = false.obs;
  Rx<DateTime> currentTime = DateTime.now().obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // getServerTime();
  //   // checkAppVersionMaintenance();
  // }

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
      Get.dialog(
        GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: "Something went wrong! \n Error Code: $error",
          type: "error",
          buttonNumber: 0,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchUrl(value) async {
    if (!await launchUrl(Uri.parse(value.appURL!))) {
      Get.dialog(
        const GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message:
              "Something went wrong! \n Please update the app in Play Store or App Store",
          type: "error",
          buttonNumber: 0,
        ),
      );
    }
  }

  Future checkAppVersionMaintenance() async {
    _checker.checkUpdate().then((value) async {
      if (value.canUpdate) {
        Get.dialog(
          Dialog(
            child: Container(
              width: Get.width * .8,
              height: Get.height * .7,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Update Available",
                    style: TextStyle(
                      color: gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value.newVersion ?? "1.0.0",
                    style: const TextStyle(color: gray),
                  ),
                  Image.asset('assets/images/maintenance.jpg'),
                  SizedBox(
                    width: Get.width * .6,
                    child: const Text(
                      "To Continue using the GEMS: Time and Attendance app, you must update the latest version",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: gray, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                    ),
                    onPressed: () {
                      _launchUrl(value);
                    },
                    child: const Text("Okay",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
        // print(value.currentVersion);
        // print(value.newVersion);
        // print(value.appURL);
        // print(value.errorMessage);
      } else {
        //   try {
        //     isLoading.value = true;
        //     var response = await apiCall.postRequest(
        //         {'version': value.currentVersion}, '/check-maintenance');
        //     var result = jsonDecode(response.body);
        //     if (result.containsKey('success') && result['success']) {
        //       isMaintenance.value =
        //           result['data']['under_maintenance'] == 1 ? true : false;
        //       if (isMaintenance.isTrue) {
        //         Get.dialog(
        //           Dialog(
        //             child: Container(
        //               width: Get.width * .8,
        //               height: Get.height * .6,
        //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //               decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   const SizedBox(height: 10),
        //                   const Text(
        //                     "Under Maintenance",
        //                     style: TextStyle(
        //                       color: gray,
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                   Image.asset('assets/images/maintenance.jpg'),
        //                   SizedBox(
        //                     width: Get.width * .7,
        //                     child: const Text(
        //                       "The page you're looking for is currently under maintenance and will be back soon.",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(color: gray, fontSize: 13),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //           barrierDismissible: false,
        //         );
        //       }
        //     } else {}
        //   } catch (error) {
        //     if (error.toString().contains('html')) {
        //       isMaintenance.value = true;
        //       Get.dialog(
        //         Dialog(
        //           child: Container(
        //             width: Get.width * .8,
        //             height: Get.height * .6,
        //             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(20),
        //             ),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 const SizedBox(height: 10),
        //                 const Text(
        //                   "Under Maintenance",
        //                   style: TextStyle(
        //                     color: gray,
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.w500,
        //                   ),
        //                 ),
        //                 Image.asset('assets/images/maintenance.jpg'),
        //                 SizedBox(
        //                   width: Get.width * .7,
        //                   child: const Text(
        //                     "The page you're looking for is currently under maintenance and will be back soon.",
        //                     textAlign: TextAlign.center,
        //                     style: TextStyle(color: gray, fontSize: 13),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         barrierDismissible: false,
        //       );
        //     } else {
        //       Get.dialog(
        //         GemsDialog(
        //           title: "Oops",
        //           hasMessage: true,
        //           withCloseButton: true,
        //           hasCustomWidget: false,
        //           message: "Something went wrong! \n Error Code: $error",
        //           type: "error",
        //           buttonNumber: 0,
        //         ),
        //       );
        //     }
        //   } finally {
        //     isLoading.value = false;
        //   }
      }
    });
  }
}
