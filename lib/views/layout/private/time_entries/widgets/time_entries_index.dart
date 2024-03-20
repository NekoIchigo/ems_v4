import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TimeEntriesIndex extends StatefulWidget {
  const TimeEntriesIndex({super.key});

  @override
  State<TimeEntriesIndex> createState() => _TimeEntriesIndexState();
}

class _TimeEntriesIndexState extends State<TimeEntriesIndex> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthController _authService = Get.find<AuthController>();

  final List _list = [
    {'day': 1, 'label': 'Today'},
    {'day': 7, 'label': 'Last 7 days'},
    {'day': 30, 'label': 'Last 30 days'},
    {'day': 90, 'label': 'Last 3 months'},
    {'day': 0, 'label': 'Custom date range'},
  ];

  final ScrollController _scrollController = ScrollController();

  late Object dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = _list[0];
    _scrollController.addListener(_scrollListener);
    // _timeEntriesController.hasClose.value = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _timeEntriesController.getNextListPage();
    }
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
                color: Colors.white,
                border: Border.all(color: lightGray),
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
                  dropdownColor: Colors.white,
                  elevation: 16,
                  isExpanded: true,
                  style: const TextStyle(color: gray),
                  onChanged: (value) async {
                    if (value["day"] == 0) {
                      List? dates = await Get.bottomSheet(
                        const CustomDateBottomsheet(type: "range"),
                      );
                      if (dates != null) {
                        _timeEntriesController.getAttendanceList(
                          employeeId: _authService.employee!.value.id,
                          days: value["day"],
                          startDate: dates[0],
                          endDate: dates[1],
                        );
                      }
                    } else {
                      _timeEntriesController.getAttendanceList(
                        employeeId: _authService.employee!.value.id,
                        days: value["day"],
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
                          const Icon(Icons.date_range_rounded, color: gray),
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
                height: size.height * .55,
                child: _timeEntriesController.isLoading.isTrue
                    ? const ListShimmer(listLength: 10)
                    : _timeEntriesController.attendances.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _timeEntriesController.attendances.length,
                            itemBuilder: (context, index) {
                              final attendance =
                                  _timeEntriesController.attendances[index];

                              return ElevatedButton(
                                onPressed: () {
                                  context.push('/attendance-log');
                                  _timeEntriesController.attendanceIndex.value =
                                      index;
                                  _timeEntriesController.hasClose.value = true;
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                  shape: LinearBorder.bottom(
                                    side: const BorderSide(color: lightGray),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    listItem(
                                      attendance.formattedClockIn ??
                                          "??/??/??/ | ??:??",
                                      attendance.clockedInLocationType ==
                                          'Within Vicinity',
                                      "IN",
                                      size,
                                    ),
                                    const SizedBox(height: 10),
                                    listItem(
                                      attendance.clockOutAt != null
                                          ? attendance.formattedClockOut ??
                                              "No Record"
                                          : "No Record",
                                      attendance.clockedOutLocationType ==
                                          'Within Vicinity',
                                      "OUT",
                                      size,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const NoResult(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(String dateTime, bool inOut, String clockType, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * .68,
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  clockType,
                  style: const TextStyle(
                    color: gray,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Text(
                dateTime,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: gray,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
        Visibility(
          visible: dateTime != "No Record",
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                inOut ? colorSuccess : colorError, BlendMode.srcIn),
            child: SvgPicture.asset(
              inOut
                  ? "assets/svg/within_vicinity.svg"
                  : "assets/svg/outside_vicinity.svg",
              height: 25,
            ),
          ),
        ),
      ],
    );
  }
}
