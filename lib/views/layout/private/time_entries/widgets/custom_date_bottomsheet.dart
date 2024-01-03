import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get/get.dart';

class CustomDateBottomsheet extends StatefulWidget {
  const CustomDateBottomsheet({super.key});

  @override
  State<CustomDateBottomsheet> createState() => _CustomDateBottomsheetState();
}

class _CustomDateBottomsheetState extends State<CustomDateBottomsheet> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();
  final AuthService _authService = Get.find<AuthService>();
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
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "By custom date range:",
                style: TextStyle(color: primaryBlue, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * .4,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
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
                  if (_dates.length == 2) {
                    _timeEntriesController.getAttendanceList(
                      context: context,
                      employeeId: _authService.employee.value.id,
                      months: 0,
                      startDate: _dates[0],
                      endDate: _dates[1],
                    );
                    Get.back();
                  } else {
                    Get.snackbar("Invalid Action",
                        "Please select the custom date range.",
                        backgroundColor: colorError, colorText: Colors.white);
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
