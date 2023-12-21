import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/models/attendance.dart';
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

  @override
  Widget build(BuildContext context) {
    final Attendance selectedRecord = _timeEntriesController
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
                height: Get.height * .35,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: gray),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedRecord.clockedInAt!,
                      style: const TextStyle(
                        color: primaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Reports at:'),
                        const SizedBox(width: 50),
                        Flexible(
                          child: Text(
                            _authService.company.value.name,
                            style: const TextStyle(color: primaryBlue),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedRecord.clockedInLocationType!),
                        const SizedBox(width: 30),
                        const Text(
                          "View Map",
                          style: TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GPS Location:'),
                        const SizedBox(width: 30),
                        Text(
                          selectedRecord.clockedInLocation!,
                          style: const TextStyle(color: primaryBlue),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Health Cheack:'),
                        const SizedBox(width: 23),
                        Text(
                          selectedRecord.healthCheck ?? 'View Symptoms',
                          style: const TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Get.height * .40,
              child: Visibility(
                visible: selectedRecord.clockedOutAt != '',
                child: Container(
                  width: Get.width * .9,
                  height: Get.height * .35,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: gray),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedRecord.clockedOutAt!,
                        style: const TextStyle(
                          color: primaryBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Reports at:'),
                          const SizedBox(width: 50),
                          Flexible(
                            child: Text(
                              _authService.company.value.name,
                              style: const TextStyle(color: primaryBlue),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedRecord.clockedOutLocationType!),
                          const SizedBox(width: 30),
                          const Text(
                            "View Map",
                            style: TextStyle(
                              color: primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('GPS Location:'),
                          const SizedBox(width: 30),
                          Text(
                            selectedRecord.clockedOutLocation!,
                            style: const TextStyle(color: primaryBlue),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Health Cheack:'),
                          const SizedBox(width: 23),
                          Text(
                            selectedRecord.healthCheck ?? 'View Symptoms',
                            style: const TextStyle(
                              color: primaryBlue,
                              decoration: TextDecoration.underline,
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
              top: Get.height * .385,
              left: 40,
              child: Visibility(
                visible: selectedRecord.clockedOutAt != '',
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
