import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/buttons/announcement_button.dart';
import 'package:flutter/material.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
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
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final MainNavigationController _mainNavigationController =
      Get.find<MainNavigationController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final HomeController _homeController = Get.find<HomeController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  late DateTime currentTime;
  late String date, greetings;
  String? reasonError, shiftId = "";

  @override
  void initState() {
    super.initState();

    currentTime = _settings.currentTime.value;
    date = DateFormat("EEEE, MMM dd y").format(currentTime);
    greetings = _dateTimeUtils.getGreeting(currentTime.hour);
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

              additionalShift(size),
              // announcementSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingWidget(Size size) {
    return Obx(
      () => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  date,
                  style: const TextStyle(
                    color: gray,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '$greetings ${_auth.employee!.value.firstName}!',
                  style: const TextStyle(
                    color: gray,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _homeController.isDropdownEnable.isTrue
                      ? 'Choose shift'
                      : "Today's shift",
                  style: const TextStyle(
                    color: gray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _homeController.isShowDropDown.isFalse,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: gray),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _homeController.scheduleList.first,
                          style:
                              const TextStyle(color: primaryBlue, fontSize: 13),
                        ),
                        Visibility(
                          visible: _homeController.hasSecondShift.isTrue,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              _homeController.scheduleList.last,
                              style: const TextStyle(
                                  color: primaryBlue, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _homeController.isShowDropDown.isTrue,
                  child: DropdownMenu<String>(
                    width: size.width * .9,
                    hintText: "-Select-",
                    errorText: reasonError,
                    enabled: _homeController.isDropdownEnable.isTrue,
                    textStyle:
                        const TextStyle(color: primaryBlue, fontSize: 13),
                    initialSelection:
                        _homeController.initialDropdownString.value != ""
                            ? _homeController.initialDropdownString.value
                            : null,
                    inputDecorationTheme: InputDecorationTheme(
                      isDense: true,
                      errorMaxLines: 1,
                      constraints: BoxConstraints.tight(
                        Size.fromHeight(reasonError != null ? 63 : 40),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      hintStyle: const TextStyle(color: gray, fontSize: 13),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: gray),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: gray),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: colorError),
                      ),
                    ),
                    onSelected: (String? value) {
                      shiftId = value;
                      _homeController.checkCurrentAttendanceRecordBySchedule();
                      reasonError = null;
                      _homeController.initialDropdownString.value = value ?? "";
                      _homeController.isSecondShift.value =
                          _homeController.scheduleList.indexOf(value) != 0;
                      setState(() {});
                    },
                    menuStyle: const MenuStyle(
                      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    dropdownMenuEntries: _homeController.scheduleList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                        labelWidget: Text(
                          value,
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(primaryBlue),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Visibility(
                  visible: _homeController.hasSecondShift.isTrue &&
                      _homeController.isClockOut.isTrue,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "To see your other shift, you must clock out this shift.",
                      style: TextStyle(
                        color: gray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
              Visibility(
                visible: _homeController.isFirstShiftComplete.isTrue,
                child: const Text(
                  "Select you next shift to submit your new clock-in.",
                  style: TextStyle(color: gray, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _homeController.greetings.value,
                style: const TextStyle(color: gray, fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buttonSection(Size size) {
    return SizedBox(
      height: size.height * .5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _homeController.isClockInOutComplete.isTrue
              ? Positioned(
                  top: 50,
                  child: Image.asset('assets/images/EMS1.png',
                      width: size.width * .62),
                )
              : Positioned(
                  top: 20,
                  child: Stack(
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
                                backgroundColor:
                                    _homeController.isClockOut.isTrue
                                        ? colorError
                                        : colorSuccess,
                              ),
                              onPressed: () {
                                if (_homeController.isDropdownEnable.isTrue &&
                                    _homeController
                                            .initialDropdownString.value ==
                                        "") {
                                  reasonError = "Please select a shift.";
                                  setState(() {});
                                } else {
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          Positioned(
            top: 7,
            child: Text(
              DateFormat("hh:mm a").format(_settings.currentTime.value),
              style: const TextStyle(
                color: gray,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Visibility(
              visible: _homeController.isMobileUser.isTrue,
              child: detailsSection(size),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Visibility(
                visible: _homeController.isMobileUser.isFalse,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: () {
                      _mainNavigationController.tabController.animateTo(1);
                      context.go("/time_entries");
                    },
                    child: const Text(
                      "View Attendance Records Here",
                      style: TextStyle(
                        color: gray,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget detailsSection(Size size) {
    return SizedBox(
      height: size.height * .16,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, color: primaryBlue),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Clock In',
                    style: TextStyle(
                      color: gray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  _dateTimeUtils.formatTime(
                      dateTime: _homeController.attendance.value.clockInAt),
                  style: const TextStyle(
                    color: gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Visibility(
                  visible: _timeEntriesController.hasPrevAttendance.isTrue,
                  child: Text(
                    _dateTimeUtils.formatTime(
                        dateTime: _timeEntriesController
                            .prevAttendance.value.clockInAt),
                    style: const TextStyle(
                      color: gray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 140,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    color: gray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget additionalShift(Size size) {
    return Visibility(
      visible: _homeController.isClockInOutComplete.isTrue &&
          _homeController.isMobileUser.isTrue,
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
