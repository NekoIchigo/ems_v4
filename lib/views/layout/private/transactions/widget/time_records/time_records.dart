import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TimeRecords extends StatefulWidget {
  const TimeRecords({super.key});

  @override
  State<TimeRecords> createState() => _TimeRecordsState();
}

class _TimeRecordsState extends State<TimeRecords> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => SizedBox(
                          height: size.height * .55,
                          child: _timeEntriesController.isLoading.isTrue
                              ? const ListShimmer(listLength: 10)
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.calendar_month_rounded,
                                            color: bgPrimaryBlue,
                                          ),
                                          trailing: const Icon(
                                            Icons.chevron_right_rounded,
                                            color: gray,
                                          ),
                                          title: const Text(
                                            "May 1 - May 15, 2024",
                                            style:
                                                TextStyle(color: bgPrimaryBlue),
                                          ),
                                          onTap: () {
                                            // print('test');
                                            context.push('/attendance_reports');
                                          },
                                        ),
                                        const Divider(),
                                      ],
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
}
