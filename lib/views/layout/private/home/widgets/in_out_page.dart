import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/widgets/buttons/announcement_button.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
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
  final AuthController _authViewService = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final HomeController _homeController = Get.find<HomeController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  late AttendanceRecord attendance;
  late DateTime currentTime;
  late String date, greetings;

  @override
  void initState() {
    super.initState();
    attendance = _homeController.attendance.value;
    currentTime = _settings.currentTime.value;
    date = DateFormat("EEE, MMM dd y").format(currentTime);
    greetings = _dateTimeUtils.getGreeting(currentTime.hour);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Obx(
        () => Column(
          children: [
            greetingWidget(),
            buttonSection(),
            detailsSection(),
            // additionalShift(),
            // announcementSection(),
          ],
        ),
      ),
    );
  }

  Widget greetingWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greetings,
            style: const TextStyle(
              color: gray,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_authViewService.employee!.value.firstName}!',
            style: const TextStyle(
              color: gray,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _homeController.isClockInOutComplete.isTrue
                ? 'See you tomorrow'
                : _homeController.isClockOut.isTrue
                    ? 'Have a great day at work!'
                    : 'Begin another day by clocking in.',
            style: const TextStyle(color: gray, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                'Today\'s Schedule : ',
                style: TextStyle(color: gray, fontWeight: FontWeight.bold),
              ),
              Text(
                '08:30 am to 06:30 pm',
                style: TextStyle(color: gray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonSection() {
    return SizedBox(
      height: Get.height * .38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _homeController.isClockInOutComplete.isTrue
              ? Positioned(
                  top: 0,
                  child: Image.asset('assets/images/EMS1.png',
                      width: Get.width * .62),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: _homeController.isClockOut.isTrue
                          ? Lottie.asset("assets/lottie/Clock-out.json",
                              width: 300)
                          : Lottie.asset("assets/lottie/Clock-in.json",
                              width: 300),
                    ),
                    Positioned(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(Get.width * .38, Get.width * .38),
                          shape: const CircleBorder(),
                          backgroundColor: _homeController.isClockOut.isTrue
                              ? colorError
                              : colorSuccess,
                        ),
                        onPressed: () {
                          if (_homeController.isClockOut.isFalse) {
                            _homeController.setClockInLocation().then((value) {
                              // Get.to(() => const HomeInfoPage(),
                              //     id: _homeController.routerKey);
                              _homeController.isWhite.value = true;
                              _homeController.pageName.value = '/home/info';
                            });
                          } else {
                            _homeController.setClockOutLocation().then((value) {
                              // Get.to(() => const HomeInfoPage(),
                              //     id: _homeController.routerKey);
                              _homeController.isWhite.value = true;
                              _homeController.pageName.value = '/home/info';
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
                            fontSize: 20,
                            color: Colors.white,
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
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  DateFormat("hh:mm a").format(_settings.currentTime.value),
                  style: const TextStyle(
                    color: gray,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(
                    color: gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 20),
      height: Get.height * .14,
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
                  _dateTimeUtils.formatTime(dateTime: attendance.clockInAt),
                  style: const TextStyle(color: gray, fontSize: 13),
                ),
              ),
              const Text(
                'Clock In',
                style: TextStyle(color: gray, fontSize: 13),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.access_time_filled, color: primaryBlue),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _dateTimeUtils.formatTime(dateTime: attendance.clockOutAt),
                  style: const TextStyle(color: gray, fontSize: 13),
                ),
              ),
              const Text(
                'Clock Out',
                style: TextStyle(color: gray, fontSize: 13),
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
                        child:
                            Icon(Icons.access_time_filled, color: primaryBlue)),
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
                      dateTimeIn: attendance.clockInAt,
                      dateTimeOut: attendance.clockOutAt),
                  style: const TextStyle(color: gray, fontSize: 13),
                ),
              ),
              const Text(
                'Working Hrs',
                style: TextStyle(color: gray, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget additionalShift() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 10),
              Text(
                'Your additional work shift:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Shift #2: 01:00 pm to 05:30 pm'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedCustomButton(
                onPressed: () {
                  _homeController.setClockInLocation().then((value) {
                    // Get.to(() => const HomeInfoPage(),
                    //     id: _homeController.routerKey);
                    _homeController.isWhite.value = true;
                    _homeController.pageName.value =
                        '/home/additional_shift_info:clock_in';
                  });
                },
                label: 'Clock in',
                size: Size(Get.width * .42, 40),
                radius: 10,
                bgColor: Colors.white,
                textColor: colorSuccess,
                borderColor: colorSuccess,
              ),
              RoundedCustomButton(
                onPressed: () {
                  _homeController.setClockOutLocation().then((value) {
                    // Get.to(() => const HomeInfoPage(),
                    //     id: _homeController.routerKey);
                    _homeController.isWhite.value = true;
                    _homeController.pageName.value =
                        '/home/additional_shift_info:clock_out';
                  });
                },
                label: 'Clock out',
                size: Size(Get.width * .42, 40),
                radius: 10,
                bgColor: Colors.white,
                textColor: red,
                borderColor: red,
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget announcementSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Announcement',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnnouncementButton(
                onPressed: () {},
                date: DateTime.now(),
                title: 'Trick or Treat',
              ),
              AnnouncementButton(
                onPressed: () {},
                date: DateTime.now(),
                title: 'Trick or Treat',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
