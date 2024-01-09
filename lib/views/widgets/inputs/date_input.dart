import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  const DateInput({super.key});

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
