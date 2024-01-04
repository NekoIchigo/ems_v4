import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeEntriesIndex extends StatefulWidget {
  const TimeEntriesIndex({super.key});

  @override
  State<TimeEntriesIndex> createState() => _TimeEntriesIndexState();
}

class _TimeEntriesIndexState extends State<TimeEntriesIndex> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthService _authService = Get.find<AuthService>();

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
                  onChanged: (value) {
                    // This is called when the user selects an item.
                    if (value["month"] == 0) {
                      Get.bottomSheet(const CustomDateBottomsheet());
                    } else {
                      _timeEntriesController.getAttendanceList(
                        employeeId: _authService.employee.value.id,
                        months: value["month"],
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
              () => SizedBox(
                height: Get.height * .55,
                child: _timeEntriesController.isLoading.isTrue
                    ? const ListShimmer(listLength: 10)
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _timeEntriesController.attendances.length,
                        itemBuilder: (context, index) {
                          final attendance =
                              _timeEntriesController.attendances[index];

                          return Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            height: 70,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: lightGray),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                _timeEntriesController.pageName.value =
                                    '/atttendance-log';
                                _timeEntriesController.attendanceIndex.value =
                                    index;
                                _timeEntriesController.hasClose.value = true;
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: primaryBlue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        attendance.clockedInAt!,
                                        style: const TextStyle(
                                          color: primaryBlue,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          attendance.clockedInLocationType!,
                                          overflow: TextOverflow.ellipsis,
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
                                    visible: attendance.clockedOutAt != '',
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
                                          attendance.clockedOutAt!,
                                          style: const TextStyle(
                                            color: primaryBlue,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            attendance.clockedOutLocationType!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
    );
  }
}
