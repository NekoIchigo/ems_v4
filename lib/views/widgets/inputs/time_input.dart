import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimeInput extends StatefulWidget {
  final ValueChanged<String> selectedTime;
  const TimeInput({super.key, required this.selectedTime});

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  String _selectedTime = '00:00 AM';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.dial,
            ) ??
            TimeOfDay.now();

        String period = time.period == DayPeriod.am ? 'AM' : 'PM';

        setState(() {
          _selectedTime =
              "${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} $period";
          widget.selectedTime(_selectedTime);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: gray,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            _selectedTime,
            style: defaultStyle,
          ),
        ),
      ),
    );
  }
}
