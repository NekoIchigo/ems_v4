import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/router/router.dart';
import 'package:flutter/material.dart';

class WeekInput extends StatefulWidget {
  final bool readOnly;
  final ValueChanged<DateTimeRange?> onDateTimeChanged;

  const WeekInput({
    super.key,
    this.readOnly = false,
    required this.onDateTimeChanged,
  });

  @override
  State<WeekInput> createState() => _WeekInputState();
}

class _WeekInputState extends State<WeekInput> {
  DateTime? _selectedDay;
  DateTimeRange? _selectedWeekRange;
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  void _selectWeek(DateTime selectedDay) {
    final firstDayOfWeek = selectedDay.weekday == DateTime.sunday
        ? selectedDay
        : selectedDay.subtract(Duration(days: selectedDay.weekday));
    final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    setState(() {
      _selectedWeekRange =
          DateTimeRange(start: firstDayOfWeek, end: lastDayOfWeek);
      widget.onDateTimeChanged(_selectedWeekRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        if (!widget.readOnly) {
          await showModalBottomSheet(
            context: navigatorKey.currentContext!,
            builder: (context) => Container(
              height: size.height * .6,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: size.width * 0.2,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select a week:",
                        style: TextStyle(color: primaryBlue, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .4,
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        rangeBidirectional: false,
                        allowSameValueSelection: true,
                        calendarType: CalendarDatePicker2Type.single,
                      ),
                      value: [_selectedDay],
                      onValueChanged: (List<DateTime?> values) {
                        if (values.isNotEmpty && values.first != null) {
                          _selectedDay = values.first;
                          _selectWeek(_selectedDay!);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
          // widget.onDateTimeChanged(_dates);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 25),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDay != null
                  ? "${_dateTimeUtils.formatDate(dateTime: _selectedWeekRange?.start)} - ${_dateTimeUtils.formatDate(dateTime: _selectedWeekRange?.end)}"
                  : "mm/dd/yyyy - mm/dd/yyyy",
              style: defaultStyle,
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
