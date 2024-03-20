import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TimeEntriesList extends StatefulWidget {
  const TimeEntriesList({super.key});

  @override
  State<TimeEntriesList> createState() => _TimeEntriesListState();
}

class _TimeEntriesListState extends State<TimeEntriesList> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthController _authService = Get.find<AuthController>();

  final List _list = [
    {'month': 1, 'label': 'Last month'},
    {'month': 6, 'label': 'Last 6 months'},
    {'month': 12, 'label': 'Last 12 months'},
    {'month': 24, 'label': 'Last 24 months'},
    {'month': 0, 'label': 'Custom date range'},
  ];

  late Object dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = _list[0];
    // _timeEntriesController.hasClose.value = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Showing records for',
              style: TextStyle(color: gray, fontSize: 12),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: bgSecondaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  iconEnabledColor: Colors.white,
                  // hint: Text(
                  //   "Select your reason/purpose here",
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  value: dropdownValue,
                  dropdownColor: bgSecondaryBlue,
                  elevation: 16,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) async {
                    if (value["month"] == 0) {
                      List dates = await Get.bottomSheet(
                        const CustomDateBottomsheet(type: "range"),
                      );
                      _timeEntriesController.getAttendanceList(
                        employeeId: _authService.employee!.value.id,
                        days: value["month"],
                        startDate: dates[0],
                        endDate: dates[1],
                      );
                    } else {
                      _timeEntriesController.getAttendanceList(
                        employeeId: _authService.employee!.value.id,
                        days: value["month"],
                      );
                    }
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: _list.map<DropdownMenuItem<dynamic>>((dynamic value) {
                    return DropdownMenuItem<dynamic>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.date_range_rounded,
                              color: Colors.white),
                          const SizedBox(width: 10),
                          Text(value['label']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Obx(
              () => Builder(builder: (context) {
                return SizedBox(
                  height: size.height * .55,
                  child: _timeEntriesController.isLoading.isTrue
                      ? const ListShimmer(listLength: 10)
                      : _timeEntriesController.attendances.isNotEmpty
                          ? ListView.builder(
                              // TODO : paginate every scroll
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  _timeEntriesController.attendances.length,
                              itemBuilder: (context, index) {
                                final attendance =
                                    _timeEntriesController.attendances[index];

                                return Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: lightGray),
                                    ),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    onTap: () {
                                      context.go('/attendance-log');
                                      _timeEntriesController
                                          .attendanceIndex.value = index;
                                      _timeEntriesController.hasClose.value =
                                          true;
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
                                              attendance.formattedClockIn ??
                                                  "??/??/??/ | ??:??",
                                              style: const TextStyle(
                                                color: primaryBlue,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                attendance
                                                        .clockedInLocationType ??
                                                    "",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: gray,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              attendance.clockOutAt != null,
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
                                                attendance.formattedClockOut ??
                                                    "??/??/??/ | ??:??",
                                                style: const TextStyle(
                                                  color: primaryBlue,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  attendance
                                                          .clockedOutLocationType ??
                                                      "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: gray,
                                                    fontSize: 13,
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
                            )
                          : const NoResult(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
