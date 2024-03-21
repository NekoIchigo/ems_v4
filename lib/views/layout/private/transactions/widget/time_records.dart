import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
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
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return EMSContainer(
      child: Container(
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
                        MonthFilterDropdown(
                          onChanged: (p0) {},
                        ),
                        Obx(
                          () => SizedBox(
                            height: size.height * .55,
                            child: _timeEntriesController.isLoading.isTrue
                                ? const ListShimmer(listLength: 10)
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _timeEntriesController
                                        .attendances.length,
                                    itemBuilder: (context, index) {
                                      final attendance = _timeEntriesController
                                          .attendances[index];

                                      return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1, color: lightGray),
                                          ),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            _timeEntriesController.pageName
                                                .value = '/attendance-log';
                                            _timeEntriesController
                                                .attendanceIndex.value = index;
                                            _timeEntriesController
                                                .hasClose.value = true;
                                          },
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    color: primaryBlue,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Text(
                                                    attendance
                                                            .formattedClockIn ??
                                                        "??/??/??/ | ??:??",
                                                    style: const TextStyle(
                                                      color: primaryBlue,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                      attendance
                                                              .clockedInLocationType ??
                                                          "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: darkGray,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible:
                                                    attendance.clockOutAt !=
                                                        null,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.access_time_filled,
                                                      color: primaryBlue,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Text(
                                                      attendance
                                                              .formattedClockOut ??
                                                          "??/??/??/ | ??:??",
                                                      style: const TextStyle(
                                                        color: primaryBlue,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      child: Text(
                                                        attendance
                                                                .clockedOutLocationType ??
                                                            "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color: darkGray,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: const Icon(
                                            Icons.navigate_next,
                                            color: gray,
                                            size: 20,
                                          ),
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
      ),
    );
  }
}
