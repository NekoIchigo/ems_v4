import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get/get.dart';

class CustomDateBottomsheet extends StatefulWidget {
  final String type; // range or default single

  const CustomDateBottomsheet({super.key, required this.type});

  @override
  State<CustomDateBottomsheet> createState() => _CustomDateBottomsheetState();
}

class _CustomDateBottomsheetState extends State<CustomDateBottomsheet> {
  List<DateTime?> _dates = <DateTime?>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .6,
      width: Get.width,
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
            width: Get.width * 0.2,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.type == "range"
                    ? "Select the date range:"
                    : "Select the date",
                style: const TextStyle(color: primaryBlue, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * .4,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: widget.type == "range"
                    ? CalendarDatePicker2Type.range
                    : CalendarDatePicker2Type.single,
              ),
              value: _dates,
              onValueChanged: (dates) => _dates = dates,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedCustomButton(
                onPressed: () => Get.back(),
                label: "Cancel",
                bgColor: Colors.grey,
                radius: 8,
                size: Size(Get.width * .4, 40),
              ),
              RoundedCustomButton(
                onPressed: () {
                  if (widget.type == "range") {
                    if (_dates.length == 2) {
                      Get.back(result: _dates);
                    } else {
                      Get.snackbar(
                        "Invalid Action",
                        "Please select the date range.",
                        backgroundColor: colorError,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    if (_dates.isNotEmpty) {
                      Get.back(result: _dates[0]);
                    } else {
                      Get.snackbar(
                        "Invalid Action",
                        "Please select a date.",
                        backgroundColor: colorError,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                label: "Submit",
                bgColor: primaryBlue,
                radius: 8,
                size: Size(Get.width * .4, 40),
              ),
            ],
          )
        ],
      ),
    );
  }
}
