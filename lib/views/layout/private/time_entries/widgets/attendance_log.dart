import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/utils/map_launcher.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/time_entries_health_declaration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceLog extends StatefulWidget {
  const AttendanceLog({super.key});

  @override
  State<AttendanceLog> createState() => _AttendanceLogState();
}

class _AttendanceLogState extends State<AttendanceLog> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthService _authService = Get.find<AuthService>();
  final MapLauncher _mapLuncher = MapLauncher();
  bool isClockIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_timeEntriesController
        .attendances[_timeEntriesController.attendanceIndex.value]
        .clockedOutLocationSetting);
  }

  @override
  Widget build(BuildContext context) {
    final AttendanceRecord selectedRecord = _timeEntriesController
        .attendances[_timeEntriesController.attendanceIndex.value];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: Get.height * .8,
        child: Stack(
          alignment: Alignment.topCenter,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Positioned(
              top: 13,
              child: Container(
                width: Get.width * .9,
                height: Get.height * .28,
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
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reports at:',
                          style: TextStyle(
                            color: gray,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 50),
                        Flexible(
                          child: Text(
                            _authService
                                .employee.value.employeeDetails.location.name,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedRecord.clockedInLocationType ?? "",
                          style: const TextStyle(
                            color: gray,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Column(
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
                                  color: primaryBlue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              selectedRecord.clockedInLocationSetting ?? "",
                              style: const TextStyle(
                                color: primaryBlue,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GPS Location:',
                          style: TextStyle(
                            color: gray,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            selectedRecord.clockedInLocation ?? "",
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 13,
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
                          const Text(
                            'Health Check:',
                            style: TextStyle(
                              color: gray,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 30),
                          InkWell(
                            onTap: () {
                              Get.to(() => TimeEntriesHealthDeclaration(
                                    attendanceRecord: selectedRecord,
                                  ));
                            },
                            child: const Text(
                              'View Symptoms',
                              style: TextStyle(
                                color: primaryBlue,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Get.height * .35,
              child: Visibility(
                visible: selectedRecord.clockOutAt != null,
                child: Container(
                  width: Get.width * .9,
                  height: Get.height * .28,
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
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reports at:',
                            style: TextStyle(
                              color: gray,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 50),
                          Flexible(
                            child: Text(
                              _authService
                                  .employee.value.employeeDetails.location.name,
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRecord.clockedOutLocationType ?? "",
                            style: const TextStyle(
                              color: gray,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Column(
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
                                    color: primaryBlue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                selectedRecord.clockedOutLocationSetting ?? "",
                                style: const TextStyle(
                                  color: primaryBlue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'GPS Location:',
                            style: TextStyle(
                              color: gray,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text(
                              selectedRecord.clockedOutLocation ?? "",
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
              top: Get.height * .333,
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
    );
  }
}
