import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/main_navigation.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:ems_v4/views/widgets/loader/item_shimmer.dart';
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
  final TimeEntriesController _timeEntriesController = TimeEntriesController();

  final List _list = [
    {'day': 1, 'label': 'Today'},
    {'day': 7, 'label': 'Last 7 days'},
    {'day': 30, 'label': 'Last 30 days'},
    {'day': 90, 'label': 'Last 3 months'},
    {'day': 0, 'label': 'Custom date range'},
  ];

  final ScrollController _scrollController = ScrollController();

  late Object dropdownValue;
  List? dates;
  int paginateDays = 1;
  late Size size;
  @override
  void initState() {
    super.initState();
    dropdownValue = _list[1];
    _scrollController.addListener(_scrollListener);
    _timeEntriesController.getAttendanceList(
      days: 7,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _timeEntriesController.nextPageList(
        days: paginateDays,
        startDate: dates?[0],
        endDate: dates?[1],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Center(
              child: Text(
                'Time Entries',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Showing records for',
              style: TextStyle(color: gray, fontSize: 13),
            ),
            dropdown(),
            list(),
          ],
        ),
      ),
    );
  }

  Widget dropdown() => Container(
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
            value: dropdownValue,
            dropdownColor: Colors.white,
            elevation: 16,
            isExpanded: true,
            style: const TextStyle(color: gray),
            onChanged: (value) async {
              paginateDays = value["day"];
              if (value["day"] == 0) {
                dates = await showModalBottomSheet(
                    context: mainNavigationKey.currentContext!,
                    builder: (BuildContext context) {
                      return const CustomDateBottomsheet(type: "range");
                    });
                if (dates != null) {
                  _timeEntriesController.getAttendanceList(
                    days: value["day"],
                    startDate: dates?[0],
                    endDate: dates?[1],
                  );
                }
              } else {
                _timeEntriesController.getAttendanceList(
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
      );

  Widget list() {
    return Obx(
      () => SizedBox(
        height: size.height * .60,
        child: _timeEntriesController.isLoading.isTrue
            ? const ListShimmer(
                listLength: 10,
                withLeading: true,
              )
            : _timeEntriesController.attendances.isNotEmpty
                ? SizedBox(
                    height: size.height * .55,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _timeEntriesController.attendances.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _timeEntriesController.attendances.length) {
                          final attendance =
                              _timeEntriesController.attendances[index];

                          return ElevatedButton(
                            onPressed: () {
                              _timeEntriesController.showClose();
                              context.push('/attendance-log',
                                  extra: attendance.toMap());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              elevation: 0,
                              backgroundColor: Colors.white,
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
                        } else {
                          return _timeEntriesController.currentPage.value <
                                  _timeEntriesController.paginateLength.value
                              ? const ItemShimmer(withLeading: true)
                              : const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Text(
                                      "-- End of Records --",
                                      style: TextStyle(
                                        color: gray,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                );
                        }
                      },
                    ),
                  )
                : const NoResult(),
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
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Text(
                dateTime,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: gray,
                  fontSize: 14,
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
