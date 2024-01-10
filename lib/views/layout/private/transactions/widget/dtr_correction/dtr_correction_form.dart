import 'dart:developer';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
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
          SizedBox(
            height: Get.height * .86,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: Get.height * .86,
                child: SelectedItemTabs(
                  status: "Pending",
                  title: "DTR Correction",
                  detailPage: Column(
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
          ),
        ],
      ),
    );
  }

  Widget formField2() {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
      decoration: BoxDecoration(
        border: Border.all(color: gray),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: Get.width * .5,
                  child: DropdownMenu<String>(
                    initialSelection: _list.first,
                    inputDecorationTheme: const InputDecorationTheme(),
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries:
                        _list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                  )),
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
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    _selectedTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: const Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: primaryBlue,
                ),
                SizedBox(width: 3),
                Text(
                  'Add clock type',
                  style: TextStyle(color: primaryBlue),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
