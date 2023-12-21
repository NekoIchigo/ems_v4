
import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class InOutPage extends StatefulWidget {
  const InOutPage({super.key});

  @override
  State<InOutPage> createState() => _InOutPageState();
}

class _InOutPageState extends State<InOutPage> {
  final AuthService _authViewService = Get.find<AuthService>();
  // final InitLoadController _initLoadController = Get.find<InitLoadController>();
  final HomeController _homeController = Get.find<HomeController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  @override
  void initState() {
    // _initLoadController.getServerTime().then((value) {
    //   _initLoadController.updateCurrentTime();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Attendance attendance = _homeController.attendance.value;
    DateTime currentTime =
        DateTime.now(); //_initLoadController.currentTime.value;
    final String date = DateFormat("EEE, MMM dd").format(currentTime);
    final String greetings = 'hello'; //_initLoadController.getGreeting();

    return Obx(
      () => Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            height: Get.height * .17,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greetings,
                  style: const TextStyle(
                    color: darkGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '${_authViewService.employee.value.firstName}!',
                    style: const TextStyle(
                      color: darkGray,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Begin another day by clocking in.',
                    style: TextStyle(color: darkGray),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'Today\'s Schedule : ',
                      style: TextStyle(
                          color: darkGray, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '08:30 am to 05:30 pm',
                      style: TextStyle(color: darkGray),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height * .40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _homeController.isClockInOutComplete.isTrue
                    ? Positioned(
                        top: 0,
                        child: Image.asset('assets/images/EMS1.png',
                            width: Get.width * .75),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 0,
                            child: _homeController.isClockOut.isTrue
                                ? Lottie.asset("assets/lottie/Clock-out.json",
                                    width: 300)
                                : Lottie.asset("assets/lottie/Clock-in.json",
                                    width: 300),
                          ),
                          Positioned(
                            top: 72,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(Get.width * .38, Get.width * .38),
                                shape: const CircleBorder(),
                                backgroundColor:
                                    _homeController.isClockOut.isTrue
                                        ? colorError
                                        : colorSuccess,
                              ),
                              onPressed: () {
                                if (_homeController.isClockOut.isFalse) {
                                  _homeController
                                      .setClockInLocation()
                                      .then((value) {
                                    _homeController.isWhite.value = true;
                                    _homeController.pageName.value =
                                        '/home/info';
                                  });
                                } else {
                                  _homeController
                                      .setClockOutLocation()
                                      .then((value) {
                                    _homeController.isWhite.value = true;
                                    _homeController.pageName.value =
                                        '/home/info';
                                  });
                                }
                              },
                              child: Text(
                                _homeController.isClockOut.isTrue
                                    ? "CLOCK OUT"
                                    : "CLOCK IN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(0.0, 5.0),
                                      blurRadius: 8.0,
                                      color: Colors.white.withOpacity(.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      const Text(
                        'Time',
                        // DateFormat("hh:mm a")
                        //     .format(_initLoadController.currentTime.value),
                        style: TextStyle(
                          color: darkGray,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          color: darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            height: Get.height * .12,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Icon(Icons.access_time, color: primaryBlue),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _dateTimeUtils.formatTime(
                            dateTime: attendance.clockedInAt ?? ""),
                        style: const TextStyle(color: darkGray),
                      ),
                    ),
                    const Text(
                      'Clock In',
                      style: TextStyle(color: darkGray),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.access_time_filled, color: primaryBlue),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _dateTimeUtils.formatTime(
                            dateTime: attendance.clockedOutAt ?? ""),
                        style: const TextStyle(color: darkGray),
                      ),
                    ),
                    const Text(
                      'Clock Out',
                      style: TextStyle(color: darkGray),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      width: 31,
                      child: Stack(
                        children: [
                          Positioned(
                              child: Icon(Icons.access_time_filled,
                                  color: primaryBlue)),
                          Positioned(
                            right: 0,
                            child: Icon(Icons.access_time, color: primaryBlue),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _homeController.getWorkingHrs(
                            dateTimeIn: attendance.clockedInAt ?? "",
                            dateTimeOut: attendance.clockedOutAt ?? ""),
                        style: const TextStyle(color: darkGray),
                      ),
                    ),
                    const Text(
                      'Working Hrs',
                      style: TextStyle(color: darkGray),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
