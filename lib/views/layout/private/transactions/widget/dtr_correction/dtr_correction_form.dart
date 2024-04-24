import 'dart:developer';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
  late Size size;
  String _selectedTime = "--:-- --";

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            height: size.height * .86,
            child: SelectedItemTabs(
              status: "Pending",
              title: "DTR Correction",
              detailPage: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const NumberLabel(label: "Select the date", number: 1),
                      const SizedBox(height: 15),
                      CustomDateInput(
                        type: "single",
                        onDateTimeChanged: (value) {
                          log(value.toString());
                        },
                        child: Container(),
                      ),
                      const SizedBox(height: 15),
                      const NumberLabel(label: "Edit time record", number: 2),
                      const SizedBox(height: 15),
                      formField2(),
                      const SizedBox(height: 15),
                      formField2(),
                      const SizedBox(height: 15),
                      const ReasonInput(readOnly: true),
                      RoundedCustomButton(
                        onPressed: () {},
                        label: "Submit",
                        size: Size(size.width * .4, 40),
                        radius: 8,
                        bgColor: gray, //primaryBlue
                      ),
                      const SizedBox(height: 50),
                    ],
                    // .map((widget) => Padding(
                    //       padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    //       child: widget,
                    //     ))
                    // .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formField2() {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: gray),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text("Schedule"),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    "M-Sat 08:30 am - 05:30 pm (RD Sun)",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text("DTR"),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: lightGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    "08:30 am to --:-- --",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: gray),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    "Clock In",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
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
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: gray),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    _selectedTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: gray),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    "Clock Out",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
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
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: gray),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    _selectedTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
