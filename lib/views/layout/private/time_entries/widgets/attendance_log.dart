import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/map_launcher.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AttendanceLog extends StatefulWidget {
  const AttendanceLog({super.key});

  @override
  State<AttendanceLog> createState() => _AttendanceLogState();
}

class _AttendanceLogState extends State<AttendanceLog> {
  late Size size;
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthController _authService = Get.find<AuthController>();
  final MapLauncher _mapLuncher = MapLauncher();
  bool isClockIn = false;
  late int index;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    index = GoRouterState.of(context).extra! as int;

    final AttendanceRecord selectedRecord =
        _timeEntriesController.attendances[index];

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: size.height * .8,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              clockInDetails(selectedRecord),
              clockOutDetails(selectedRecord),
              Positioned(
                top: 0,
                left: 40,
                child: Container(
                  color: Colors.white,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: primaryBlue,
                      ),
                      Text(
                        ' Clock in:',
                        style: TextStyle(color: primaryBlue),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.height * .333,
                left: 40,
                child: Visibility(
                  visible: selectedRecord.clockOutAt != null,
                  child: Container(
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: primaryBlue,
                        ),
                        Text(
                          ' Clock out:',
                          style: TextStyle(color: primaryBlue),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget clockInDetails(AttendanceRecord selectedRecord) {
    return Positioned(
      top: 13,
      child: Container(
        width: size.width * .9,
        height: size.height * .28,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: lightGray),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedRecord.formattedClockIn ?? "??/??/??/ | ??:??",
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * .30,
                  child: const Text(
                    'Reports at:',
                    style: TextStyle(
                      color: gray,
                      fontSize: 14,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    _authService.employee!.value.employeeDetails.location.name,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * .30,
                  child: Text(
                    selectedRecord.clockedInLocationType ?? "",
                    style: const TextStyle(
                      color: gray,
                      fontSize: 14,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isClockIn = true;
                        });
                        _mapLuncher.launchMap(
                            attendanceRecord: selectedRecord, isclockin: true);
                      },
                      child: const Text(
                        "View Map",
                        style: TextStyle(
                          color: primaryBlue,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      selectedRecord.clockedInLocationSetting ?? "",
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * .30,
                  child: const Text(
                    'GPS Location:',
                    style: TextStyle(
                      color: gray,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    selectedRecord.clockedInLocation ?? "",
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: selectedRecord.healthCheck != null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .30,
                    child: const Text(
                      'Health Check:',
                      style: TextStyle(
                        color: gray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(
                        '/time-entries-health',
                        extra: index,
                      );
                    },
                    child: const Text(
                      'View Symptoms',
                      style: TextStyle(
                        color: primaryBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clockOutDetails(AttendanceRecord selectedRecord) {
    return Positioned(
      top: size.height * .35,
      child: Visibility(
        visible: selectedRecord.clockOutAt != null,
        child: Container(
          width: size.width * .9,
          height: size.height * .28,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: lightGray),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedRecord.formattedClockOut ?? "??/??/??/ | ??:??",
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .30,
                    child: const Text(
                      'Reports at:',
                      style: TextStyle(
                        color: gray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _authService
                          .employee!.value.employeeDetails.location.name,
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .30,
                    child: Text(
                      selectedRecord.clockedOutLocationType ?? "",
                      style: const TextStyle(
                        color: gray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isClockIn = true;
                          });
                          _mapLuncher.launchMap(
                              attendanceRecord: selectedRecord,
                              isclockin: false);
                        },
                        child: const Text(
                          "View Map",
                          style: TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            selectedRecord.clockedOutLocationSetting != null,
                        child: Text(
                          selectedRecord.clockedOutLocationSetting ?? "",
                          style: const TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .30,
                    child: const Text(
                      'GPS Location:',
                      style: TextStyle(
                        color: gray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      selectedRecord.clockedOutLocation ?? "",
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
