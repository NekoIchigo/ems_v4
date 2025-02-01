import 'package:ems_v4/global/controller/announcement_controller.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/dialog/announcement_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class InOutPageV2 extends StatefulWidget {
  const InOutPageV2({super.key});

  @override
  State<InOutPageV2> createState() => _InOutPageV2State();
}

class _InOutPageV2State extends State<InOutPageV2> {
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final MainNavigationController _mainNavigationController =
      Get.find<MainNavigationController>();
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final HomeController _homeController = Get.find<HomeController>();
  final AnnouncementController _announcement =
      Get.find<AnnouncementController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  late DateTime currentTime;
  late String date, greetings;
  String? reasonError, shiftId = "";

  @override
  void initState() {
    super.initState();
    _homeController.isLoading.value = false;
    currentTime = _settings.currentTime.value;
    date = DateFormat("MMMM dd, y, EEEE").format(currentTime);
    greetings = _dateTimeUtils.getGreeting(currentTime.hour);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        // color: lightGray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              greetingWidget(size),
              Visibility(
                visible: _homeController.isMobileUser.isTrue,
                child: detailsSection(size),
              ),
              weekSchedule(size),
              // additionalShift(size),
              announcementSection(size),
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
            color: bgPrimaryBlue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      greetings == 'Good morning,'
                          ? 'assets/images/sunrise.png'
                          : 'assets/images/night.png',
                      height: 50,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      DateFormat("hh:mm a").format(_settings.currentTime.value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      color: Colors.white,
                      width: 1,
                      height: 50,
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _homeController.isMobileUser.isFalse,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.warning_rounded,
                          color: colorError,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Clock-In/Out Not Allowed",
                              style: TextStyle(
                                color: colorError,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: size.width * .7,
                              child: const Text(
                                "There is no need to clock in and out here. HR has designated you to use the manual DTR/Timesheet.",
                                softWrap: true,
                                style: TextStyle(
                                  color: gray,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _homeController.isMobileUser.isTrue,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: colorSuccess,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          if (_homeController.isLoading.isFalse) {
                            await _settings.checkLocationService('/in_out');
                            await _settings.checkLocationPermission('/in_out');

                            if (_homeController.isDropdownEnable.isTrue &&
                                _homeController.initialDropdownString.value ==
                                    "") {
                              reasonError = "Please select a shift.";
                              setState(() {});
                            } else {
                              _homeController.isClockOut.value = false;
                              _homeController
                                  .setClockInLocation()
                                  .then((value) {
                                context.push('/info');
                              });
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.input_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _homeController.isLoading.isFalse
                                  ? "Clock In"
                                  : "Processing ...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: _homeController.isClockOut.isFalse
                              ? gray
                              : colorError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          if (_homeController.isLoading.isFalse) {
                            await _settings.checkLocationService('/in_out');
                            await _settings.checkLocationPermission('/in_out');

                            if (_homeController.isDropdownEnable.isTrue &&
                                _homeController.initialDropdownString.value ==
                                    "") {
                              reasonError = "Please select a shift.";
                              setState(() {});
                            } else {
                              if (_homeController.isClockOut.isTrue) {
                                _homeController
                                    .setClockOutLocation()
                                    .then((value) {
                                  context.push('/info');
                                });
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.output_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _homeController.isLoading.isFalse
                                  ? "Clock Out"
                                  : "Processing ...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailsSection(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _homeController.isDropdownEnable.isTrue
                ? "Please Choose Shift"
                : "Your Today's Shift",
            style: const TextStyle(
              color: gray700,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: _homeController.isShowDropDown.isFalse,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: size.width,
              decoration: BoxDecoration(
                color: bgLightGray,
                // border: Border.all(color: gray),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _homeController.scheduleList.first,
                    style: defaultStyle,
                  ),
                  Visibility(
                    visible: _homeController.hasSecondShift.isTrue,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        _homeController.scheduleList.last,
                        style: defaultStyle,
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
              width: size.width * .95,
              hintText: "-Select-",
              errorText: reasonError,
              enabled: _homeController.isDropdownEnable.isTrue,
              textStyle: const TextStyle(color: primaryBlue, fontSize: 13),
              initialSelection:
                  _homeController.initialDropdownString.value != ""
                      ? _homeController.initialDropdownString.value
                      : null,
              inputDecorationTheme: InputDecorationTheme(
                fillColor: bgLightGray,
                filled: true,
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
                  borderSide: BorderSide(color: bgLightGray),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: bgLightGray),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: bgLightGray),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: colorError),
                ),
              ),
              onSelected: (String? value) async {
                shiftId = value;
                final selectedIndex =
                    _homeController.scheduleList.indexOf(value!);
                _homeController.checkCurrentAttendanceRecordBySchedule();
                reasonError = null;
                _homeController.initialDropdownString.value = value;

                _homeController.isSecondShift.value =
                    _homeController.scheduleList.indexOf(value) != 0;

                _homeController.checkNewShift().then((value) {
                  if (selectedIndex == 1 &&
                      _homeController.isSecondShiftComplete.isFalse) {
                    _homeController.isClockInOutComplete.value = false;
                    _homeController.isNewShift.value = true;
                    _homeController.isFirstShiftComplete.value = false;
                    _homeController.greetings.value =
                        "To begin your next shift, clock in again";
                  }
                });

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
                    foregroundColor: MaterialStatePropertyAll(primaryBlue),
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
                style: smallStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget weekSchedule(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: _homeController.isMobileUser.isFalse,
              child: const SizedBox(height: 20)),
          Text(
            "${_homeController.dateRange.value} Shifts",
            style: const TextStyle(
              color: gray700,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: size.height * .25,
            child: ListView.builder(
              padding: EdgeInsetsDirectional.zero,
              itemCount: _homeController.weekSchedule.length,
              itemBuilder: (context, index) {
                final data = _homeController.weekSchedule[index];
                final date = DateTime.parse(data['date']);
                final now = DateTime.now();
                final isToday = now.year == date.year &&
                    now.month == date.month &&
                    now.day == date.day &&
                    _homeController.isMobileUser.isFalse;
                String dayAbbreviation = DateFormat('E').format(date);
                String formattedDate = DateFormat('MMMM dd, y').format(date);
                String? firstShiftRestday;
                String? secondShiftRestday;

                if (data['first_shift']['rest_days'] is List) {
                  firstShiftRestday =
                      data['first_shift']['rest_days'].join(',');
                } else {
                  firstShiftRestday = data['first_shift']['rest_days'];
                }

                if (data['second_shift'] != null &&
                    data['second_shift']['rest_days'] is List) {
                  secondShiftRestday =
                      data['second_shift']?['rest_days'].join(',');
                } else {
                  secondShiftRestday = data['second_shift']?['rest_days'];
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isToday ? bgPrimaryBlue : bgLightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        width: 80,
                        child: Center(
                          child: Text(
                            dayAbbreviation,
                            style: TextStyle(
                              color: isToday ? Colors.white : primaryBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: isToday ? defaultWhiteStyle : defaultStyle,
                          ),
                          Text(
                            '${data['first_shift']['work_start']} to ${data['first_shift']['work_end']}, Restday ${firstShiftRestday.toString()}',
                            style: isToday ? smallWhiteStyle : smallStyle,
                          ),
                          Visibility(
                            visible: data['second_shift'] != null,
                            child: Text(
                              '${data['second_shift']?['work_start']} to ${data['second_shift']?['work_end']}, Restday ${secondShiftRestday.toString()}',
                              style: isToday ? smallWhiteStyle : smallStyle,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Is shift incorrect? Click ", style: smallStyle),
              InkWell(
                onTap: () {
                  context.push('/change_schedule_form');
                },
                child: const Text(
                  "here.",
                  style: TextStyle(
                      color: primaryBlue, decoration: TextDecoration.underline),
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
            decorationColor: gray700,
            color: gray700,
          ),
        ),
      ),
    );
  }

  Widget announcementSection(Size size) {
    return Obx(
      () => Visibility(
        visible: _announcement.announcements.isNotEmpty,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),
          color: Colors.white,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Announcements',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              ColumnBuilder(
                itemCount: _announcement.announcements.length + 1,
                itemBuilder: (context, index) {
                  if (_announcement.announcements.length == index) {
                    return Column(
                      children: [
                        Visibility(
                          visible: _announcement.totalAnnouncement > 3 &&
                              _announcement.isLoading.isFalse &&
                              _announcement.currentPage.value <
                                  _announcement.paginateLength.value,
                          child: InkWell(
                            onTap: () {
                              if (_announcement.currentPage.value <
                                  _announcement.paginateLength.value) {
                                _announcement.currentPage.value++;
                                _announcement.index(false);
                              }
                            },
                            child: const Text(
                              "View more",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _announcement.isLoading.isTrue,
                          child: const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(),
                          ),
                        )
                        // Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    );
                  } else {
                    final item = _announcement.announcements[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: bgLightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              color: bgSecondaryBlue,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Date Published: ${DateFormat("MMMM dd, y").format(DateTime.parse(item['start_date']))}",
                            style: defaultStyle,
                          ),
                          Text(
                            "Posted by: ${item['user']['name']}",
                            style: defaultStyle,
                          ),
                        ],
                      ),
                    );

                    // ListTile(
                    //   contentPadding: const EdgeInsets.symmetric(
                    //       horizontal: 10, vertical: 0),
                    //   title: Text(
                    //     _dateTimeUtils
                    //         .fromLaravelDateFormat(item['start_date']),
                    //     style: blueDefaultStyle,
                    //   ),
                    //   subtitle: Text(
                    //     item['name'],
                    //     style: defaultStyle,
                    //   ),
                    //   onTap: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) {
                    //         return AnnouncementDialog(
                    //             items: [_announcement.announcements[index]]);
                    //       },
                    //     );
                    //   },
                    // );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
