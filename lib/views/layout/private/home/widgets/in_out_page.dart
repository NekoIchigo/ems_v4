import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/buttons/announcement_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final HomeController _homeController = Get.find<HomeController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  late DateTime currentTime;
  late String date, greetings;

  @override
  void initState() {
    super.initState();
    initFunctions();

    currentTime = _settings.currentTime.value;
    date = DateFormat("EEE, MMM dd y").format(currentTime);
    greetings = _dateTimeUtils.getGreeting(currentTime.hour);
  }

  Future initFunctions() async {
    await _timeEntriesController.getPreviousClockIn();
    await _settings.getServerTime();
    await _homeController.checkNewShift();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tiles-bg.png'),
          fit: BoxFit.fill,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              greetingWidget(size),
              buttonSection(size),
              detailsSection(size),
              additionalShift(size),
              // announcementSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingWidget(Size size) {
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
            style: const TextStyle(color: gray, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today\'s Schedule : ',
                style: TextStyle(color: gray, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: size.width * .5,
                child: Text(
                  '${_homeController.workStart.value} to ${_homeController.workEnd.value}',
                  style: const TextStyle(color: gray),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonSection(Size size) {
    return SizedBox(
      height: size.height * .38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _homeController.isClockInOutComplete.isTrue
              ? Positioned(
                  top: 0,
                  child: Image.asset('assets/images/EMS1.png',
                      width: size.width * .62),
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(size.width * .38, size.width * .38),
                              shape: const CircleBorder(),
                              backgroundColor: _homeController.isClockOut.isTrue
                                  ? colorError
                                  : colorSuccess,
                            ),
                            onPressed: () {
                              if (_homeController.isClockOut.isFalse) {
                                _homeController
                                    .setClockInLocation()
                                    .then((value) {
                                  context.push('/info');
                                });
                              } else {
                                _homeController
                                    .setClockOutLocation()
                                    .then((value) {
                                  context.push('/info');
                                });
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
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
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _homeController.isLoading.isTrue,
                            child: SizedBox(
                              width: size.width * .44,
                              height: size.width * .44,
                              child: CircularProgressIndicator(
                                color: _homeController.isClockOut.isTrue
                                    ? colorError
                                    : colorSuccess,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          )
                        ],
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

  Widget detailsSection(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: size.height * .16,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Icon(Icons.access_time, color: primaryBlue),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Clock In',
                  style: TextStyle(color: gray, fontSize: 14),
                ),
              ),
              Text(
                _dateTimeUtils.formatTime(
                    dateTime: _homeController.attendance.value.clockInAt),
                style: const TextStyle(
                    color: gray, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Visibility(
                visible: _timeEntriesController.hasPrevAttendance.isTrue,
                child: Text(
                  _dateTimeUtils.formatTime(
                      dateTime: _timeEntriesController
                          .prevAttendance.value.clockInAt),
                  style: const TextStyle(
                      color: gray, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(width: 50),
          Column(
            children: [
              const Icon(Icons.access_time_filled, color: primaryBlue),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Clock Out',
                  style: TextStyle(color: gray, fontSize: 14),
                ),
              ),
              Text(
                _dateTimeUtils.formatTime(
                    dateTime: _homeController.attendance.value.clockOutAt),
                style: const TextStyle(
                    color: gray, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Visibility(
                visible: _timeEntriesController.hasPrevAttendance.isTrue,
                child: Text(
                  _dateTimeUtils.formatTime(
                      dateTime: _timeEntriesController
                          .prevAttendance.value.clockOutAt),
                  style: const TextStyle(
                      color: gray, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget additionalShift(Size size) {
    return Visibility(
      visible: _homeController.isClockInOutComplete.isTrue,
      child: TextButton(
        onPressed: () {
          _homeController.isNewShift.value = true;
          _homeController.isClockOut.value = false;
          _homeController.isClockInOutComplete.value = false;
        },
        child: const Text(
          'Clock-in/ Clock out again',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: gray,
            color: gray,
          ),
        ),
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
