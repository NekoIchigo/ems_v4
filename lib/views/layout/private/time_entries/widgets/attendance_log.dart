import 'package:ems_v4/global/controller/auth_controller.dart';
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

  final AuthController _authService = Get.find<AuthController>();
  final MapLauncher _mapLuncher = MapLauncher();
  bool isClockIn = false;
  late AttendanceRecord selectedRecord;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    selectedRecord = AttendanceRecord.fromJson(
        GoRouterState.of(context).extra! as Map<String, dynamic>);

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            const SizedBox(height: 13),
            SizedBox(
              height: 50,
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Time Entries',
                      style: TextStyle(
                        color: bgSecondaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 15,
                    child: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
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
                            color: bgSecondaryBlue,
                          ),
                          Text(
                            ' Clock in:',
                            style: blueDefaultStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: selectedRecord.source == "mobile"
                        ? size.height * .333
                        : size.height * .14,
                    left: 40,
                    child: Visibility(
                      visible: selectedRecord.clockOutAt != null,
                      child: Container(
                        color: Colors.white,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              color: bgSecondaryBlue,
                            ),
                            Text(
                              ' Clock out:',
                              style: blueDefaultStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clockInDetails(AttendanceRecord selectedRecord) {
    return Positioned(
      top: 13,
      child: Container(
        width: size.width * .9,
        height: selectedRecord.source == "mobile"
            ? size.height * .28
            : size.height * .12,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: lightGray),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedRecord.formattedClockIn ?? "??/??/??/ | ??:??",
              style: const TextStyle(
                color: bgSecondaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .30,
                    child: const Text(
                      'Reports at:',
                      style: defaultStyle,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _authService
                          .employee!.value.employeeDetails.location.name,
                      style: defaultStyle,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: selectedRecord.source == "mobile",
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * .30,
                      child: Text(
                        selectedRecord.clockedInLocationType ?? "",
                        style: defaultStyle,
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
                                attendanceRecord: selectedRecord,
                                isclockin: true);
                          },
                          child: const Text(
                            "View Map",
                            style: TextStyle(
                              color: gray700,
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          selectedRecord.clockedInLocationSetting ?? "",
                          style: const TextStyle(
                            color: gray700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: selectedRecord.source == "mobile",
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * .30,
                      child: const Text(
                        'GPS Location:',
                        style: defaultStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        selectedRecord.clockedInLocation ?? "",
                        style: defaultStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: selectedRecord.healthCheck != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * .30,
                      child: const Text(
                        'Health Check:',
                        style: defaultStyle,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.push('/time-entries-health',
                            extra: selectedRecord.toMap());
                      },
                      child: const Text(
                        'View Symptoms',
                        style: TextStyle(
                          color: gray700,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clockOutDetails(AttendanceRecord selectedRecord) {
    return Positioned(
      top: selectedRecord.source == "mobile"
          ? size.height * .35
          : size.height * .16,
      child: Visibility(
        visible: selectedRecord.clockOutAt != null,
        child: Container(
          width: size.width * .9,
          height: selectedRecord.source == "mobile"
              ? size.height * .28
              : size.height * .12,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: lightGray),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedRecord.formattedClockOut ?? "??/??/??/ | ??:??",
                style: const TextStyle(
                  color: bgSecondaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * .30,
                      child: const Text(
                        'Reports at:',
                        style: defaultStyle,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _authService
                            .employee!.value.employeeDetails.location.name,
                        style: defaultStyle,
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: selectedRecord.source == "mobile",
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * .30,
                        child: Text(
                          selectedRecord.clockedOutLocationType ?? "",
                          style: defaultStyle,
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
                                  attendanceRecord: selectedRecord,
                                  isclockin: false);
                            },
                            child: const Text(
                              "View Map",
                              style: TextStyle(
                                color: gray700,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: selectedRecord.clockedOutLocationSetting !=
                                null,
                            child: Text(
                              selectedRecord.clockedOutLocationSetting ?? "",
                              style: const TextStyle(
                                color: gray700,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
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
                visible: selectedRecord.source == "mobile",
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * .30,
                        child: const Text(
                          'GPS Location:',
                          style: defaultStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          selectedRecord.clockedOutLocation ?? "",
                          style: defaultStyle,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
