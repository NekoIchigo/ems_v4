import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:flutter/material.dart';

class CustomDateInput extends StatefulWidget {
  final ValueChanged<List<DateTime?>> onDateTimeChanged;
  final String type; // range or single
  final Widget child;
  final String? fromDate;
  final String? toDate;
  final bool readOnly;
  final String? error;

  const CustomDateInput({
    super.key,
    required this.onDateTimeChanged,
    required this.child,
    required this.type,
    this.fromDate,
    this.toDate,
    this.readOnly = false,
    this.error,
  });

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  List<DateTime?> _dates = [];
  bool hasDateSelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.fromDate != null) {
      hasDateSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRange = widget.type == "range";

    return InkWell(
      onTap: () async {
        if (!widget.readOnly) {
          _dates = await showModalBottomSheet(
            context: navigatorKey.currentContext!,
            builder: (context) => CustomDateBottomsheet(type: widget.type),
          );
          widget.onDateTimeChanged(_dates);
          hasDateSelected = _dates.isNotEmpty;
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isRange ? range() : single(),
        ),
      ),
    );
  }

  List<Widget> single() {
    return [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? widget.fromDate ?? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[0]),
              style: hasDateSelected ? defaultStyle : hintStyle,
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray300,
              size: 20,
            ),
          ],
        ),
      ),
      Visibility(
        visible: widget.error != null,
        child: Text(
          widget.error ?? "",
          style: errorStyle,
        ),
      ),
      widget.child,
    ];
  }

  List<Widget> range() {
    return [
      const Text("From date", style: defaultStyle),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? widget.fromDate ?? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[0]),
              style: hasDateSelected ? defaultStyle : hintStyle,
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray300,
              size: 20,
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      const Text("End date", style: defaultStyle),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? widget.toDate ?? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[1]),
              style: hasDateSelected ? defaultStyle : hintStyle,
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray300,
              size: 20,
            ),
          ],
        ),
      ),
      Visibility(
        visible: widget.error != null,
        child: Text(
          widget.error ?? "",
          style: errorStyle,
        ),
      ),
      widget.child,
    ];
  }
}
