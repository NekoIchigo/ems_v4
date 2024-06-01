import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class CustomDateBottomsheet extends StatelessWidget {
  final String type;
  const CustomDateBottomsheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    List<DateTime?> dates = <DateTime?>[];
    Size size = MediaQuery.of(context).size;

    return Container(
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                type == "range" ? "Select the date range:" : "Select the date",
                style: const TextStyle(color: primaryBlue, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: size.height * .4,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: type == "range"
                    ? CalendarDatePicker2Type.range
                    : CalendarDatePicker2Type.single,
              ),
              value: dates,
              onValueChanged: (val) {
                dates = val;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedCustomButton(
                onPressed: () => Navigator.of(context).pop(),
                label: "Cancel",
                bgColor: Colors.grey,
                radius: 8,
                size: Size(size.width * .4, 40),
              ),
              RoundedCustomButton(
                onPressed: () {
                  if (type == "range") {
                    if (dates.length == 2) {
                      dates[0] = dates[0]?.add(
                        const Duration(seconds: 1),
                      );
                      dates[1] = dates[1]?.add(
                        const Duration(
                          hours: 23,
                          minutes: 59,
                          seconds: 59,
                        ),
                      );
                      Navigator.of(context).pop(dates);
                    } else {
                      dates.add(
                        dates[0]?.add(
                          const Duration(
                            hours: 23,
                            minutes: 59,
                            seconds: 59,
                          ),
                        ),
                      );
                      Navigator.of(context).pop(dates);

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: const Text('Please select the date range.'),
                      //     behavior: SnackBarBehavior.floating,
                      //     margin: EdgeInsets.only(
                      //       bottom: size.height - 130,
                      //       right: 20,
                      //       left: 20,
                      //     ),
                      //   ),
                      // );
                    }
                  } else {
                    if (dates.isNotEmpty) {
                      dates[0] = dates[0]?.add(
                        const Duration(seconds: 1),
                      );
                      Navigator.of(context).pop(dates);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please select a date.'),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            bottom: size.height - 130,
                            right: 20,
                            left: 20,
                          ),
                        ),
                      );
                    }
                  }
                },
                label: "Select",
                bgColor: primaryBlue,
                radius: 8,
                size: Size(size.width * .4, 40),
              ),
            ],
          )
        ],
      ),
    );
  }
}
