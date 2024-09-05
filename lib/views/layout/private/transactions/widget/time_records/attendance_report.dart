import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/time_records_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  final TimeRecordsController _recordsController =
      Get.find<TimeRecordsController>();
  late Size size;

  TextStyle labelStyle = const TextStyle(
    color: gray,
    fontSize: 11,
  );
  TextStyle valueStyle = const TextStyle(
    color: primaryBlue,
    fontSize: 11,
  );

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    String title = GoRouterState.of(context).extra as String;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 10,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: bgPrimaryBlue),
                ),
              ),
              Obx(
                () => SizedBox(
                  height: size.height * .75,
                  child: _recordsController.isLoading.isTrue
                      ? loader()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                          itemCount:
                              _recordsController.attendanceMasters.length,
                          itemBuilder: (context, index) {
                            var attendanceMaster =
                                _recordsController.attendanceMasters[index];
                            DateTime attendanceDate = DateTime.parse(
                                attendanceMaster['attendance_date']);
                            String formattedDate =
                                DateFormat('EEEE, MMMM d, yyyy')
                                    .format(attendanceDate);
                            String scheduleName =
                                attendanceMaster['schedule_name']
                                    ['schedule_name'];
                            String dayType = attendanceMaster['day_type'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: gray),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                          color: bgPrimaryBlue,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formattedDate,
                                          style:
                                              const TextStyle(color: darkGray),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    rowItem('Schedule', scheduleName),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            rowItem(
                                              'Clock In',
                                              attendanceMaster['clock_in_at'] ??
                                                  "00:00",
                                            ),
                                            rowItem(
                                              'Clock Out',
                                              attendanceMaster[
                                                      'clock_out_at'] ??
                                                  "00:00",
                                            ),
                                            rowItem(
                                              'Day Type',
                                              dayType.capitalize ?? "",
                                            ),
                                            rowItem(
                                              'Worked Hours',
                                              attendanceMaster['rwh'] ??
                                                  "00:00",
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            rowItem(
                                              'OT',
                                              attendanceMaster['ot'] ?? "00:00",
                                            ),
                                            rowItem(
                                              'Late',
                                              attendanceMaster['late'] ??
                                                  "00:00",
                                            ),
                                            rowItem(
                                              'Undertime',
                                              attendanceMaster['ut'] ?? "00:00",
                                            ),
                                            rowItem(
                                              'Night diff.',
                                              attendanceMaster['nd'] ?? "00:00",
                                            ),
                                            rowItem(
                                              'Night diff. OT',
                                              attendanceMaster['nd_ot'] ??
                                                  "00:00",
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]),
                            );
                          },
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * .23,
            child: Text(
              "$label :",
              style: labelStyle,
            ),
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  Widget loader() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: gray),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFc9c9c9),
            highlightColor: const Color(0xFFe6e6e6),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: size.width,
                  height: 18,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: size.width,
                  height: 15,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: size.width,
                  height: 15,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: size.width,
                  height: 15,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: size.width,
                  height: 15,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
