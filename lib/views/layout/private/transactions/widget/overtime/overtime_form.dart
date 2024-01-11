import 'dart:developer';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeForm extends StatefulWidget {
  const OvertimeForm({super.key});

  @override
  State<OvertimeForm> createState() => _OvertimeFormState();
}

class _OvertimeFormState extends State<OvertimeForm> {
  final List<String> _list = <String>[
    'Clock in',
    'Clock out',
  ];
  String? _dropdownValue;
  String _selectedTime = "-- : -- --";

  @override
  void initState() {
    super.initState();
    _dropdownValue = _list[0];
  }

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            height: Get.height * .86,
            child: SelectedItemTabs(
              title: "Overtime",
              detailPage: SingleChildScrollView(
                child: Column(
                  children: [
                    const NumberLabel(label: "Select the date", number: 1),
                    CustomDateInput(
                      type: "single",
                      onDateTimeChanged: (value) {
                        log(value.toString());
                      },
                      child: Container(),
                    ),
                    const NumberLabel(label: "Edit time record", number: 2),
                    formField2(),
                    const ReasonInput(readOnly: true),
                    RoundedCustomButton(
                      onPressed: () {},
                      label: "Submit",
                      size: Size(Get.width * .4, 40),
                      radius: 8,
                      bgColor: gray, //primaryBlue
                    )
                  ]
                      .map((widget) => Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                            child: widget,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formField2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overtime Start Time'),
              TimeInput(
                selectedTime: (value) {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('No. of Hours'),
              Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: darkGray))),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  "2 hours",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
