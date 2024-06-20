import 'dart:convert';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/time_records_controller.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class TimeRecords extends StatefulWidget {
  const TimeRecords({super.key});

  @override
  State<TimeRecords> createState() => _TimeRecordsState();
}

class _TimeRecordsState extends State<TimeRecords> {
  final TimeRecordsController _recordsController =
      Get.find<TimeRecordsController>();
  late Size size;

  @override
  void initState() {
    _recordsController.fetchCutoffPeriods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
            children: [
              const SizedBox(height: 25),
              const Text(
                "Time Records",
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => SizedBox(
                          height: size.height * .60,
                          child: _recordsController.isLoading.isTrue
                              ? loader()
                              : _recordsController.cutoffPeriods.isEmpty
                                  ? const NoResult()
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _recordsController
                                          .cutoffPeriods.length,
                                      itemBuilder: (context, index) {
                                        var item = _recordsController
                                            .cutoffPeriods[index];
                                        var cutoff = jsonDecode(item["cutoff"]);
                                        DateTime date =
                                            DateTime.parse(item['created_at']);

                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: gray),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.calendar_month_rounded,
                                              color: bgPrimaryBlue,
                                              size: 30,
                                            ),
                                            trailing: const Icon(
                                              Icons.chevron_right_rounded,
                                              color: gray,
                                            ),
                                            title: Text(
                                              "${cutoff['start_day']} - ${cutoff['end_day']}, ${date.year}",
                                              style: const TextStyle(
                                                color: bgPrimaryBlue,
                                              ),
                                            ),
                                            subtitle: Text(
                                              item['status'] == 0
                                                  ? "Not posted"
                                                  : "Posted",
                                              style: const TextStyle(
                                                  color: gray, fontSize: 12),
                                            ),
                                            onTap: () {
                                              _recordsController
                                                  .fetchAttendanceMasters(
                                                item['id'],
                                              );
                                              context.push(
                                                '/attendance_reports',
                                                extra:
                                                    "${cutoff['start_day']} - ${cutoff['end_day']}, ${date.year}",
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loader() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFc9c9c9),
          highlightColor: const Color(0xFFe6e6e6),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: size.width * 0.5,
            height: 50,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
