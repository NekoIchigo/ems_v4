import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDateInput extends StatefulWidget {
  final ValueChanged<List<DateTime?>> onDateTimeChanged;
  final String type; // range or single
  final Widget child;
  const CustomDateInput({
    super.key,
    required this.onDateTimeChanged,
    required this.child,
    required this.type,
  });

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  List<DateTime?> _dates = [];

  @override
  Widget build(BuildContext context) {
    final bool _isRange = widget.type == "range";

    return InkWell(
      onTap: () async {
        _dates =
            await Get.bottomSheet(CustomDateBottomsheet(type: widget.type));
        widget.onDateTimeChanged(_dates);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _isRange ? range() : single(),
        ),
      ),
    );
  }

  List<Widget> single() {
    return [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFc4c4c4)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[0]),
              style: TextStyle(color: _dates.isEmpty ? gray : Colors.black),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
      widget.child,
    ];
  }

  List<Widget> range() {
    return [
      const Text("From date"),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[0]),
              style: const TextStyle(color: gray),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      const Text("End date"),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[1]),
              style: const TextStyle(color: gray),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
      widget.child,
    ];
  }
}
