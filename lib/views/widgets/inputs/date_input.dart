import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDateInput extends StatefulWidget {
  const CustomDateInput({super.key});

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(const CustomDateBottomsheet());
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text("data"),
      ),
    );
  }
}
