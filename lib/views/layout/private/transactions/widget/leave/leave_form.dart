import 'dart:developer';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';

class LeaveForm extends StatefulWidget {
  const LeaveForm({super.key});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final TextEditingController _reason = TextEditingController();

  final List<String> _list = <String>[
    'Leave Type 1',
    'Leave Type 2',
    'Leave Type 3',
  ];

  late Size size;

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
              title: "Leave",
              detailPage: SingleChildScrollView(
                child: Column(
                  children: [
                    const NumberLabel(label: "Select the date", number: 1),
                    CustomDateInput(
                      type: "range",
                      onDateTimeChanged: (value) {
                        log(value.toString());
                      },
                      child: Container(),
                    ),
                    const NumberLabel(label: "Edit time record", number: 2),
                    formField2(),
                    ReasonInput(
                      readOnly: true,
                      controller: _reason,
                    ),
                    RoundedCustomButton(
                      onPressed: () {},
                      label: "Submit",
                      size: Size(size.width * .4, 40),
                      radius: 8,
                      bgColor: gray, //primaryBlue
                    ),
                    const SizedBox(height: 50),
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
      padding: const EdgeInsets.only(left: 25.0),
      child: Column(
        children: [
          DropdownMenu<String>(
            initialSelection: _list.first,
            width: size.width * .84,
            textStyle: defaultStyle,
            trailingIcon: const Icon(
              Icons.arrow_drop_down_rounded,
              size: 25,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              constraints: BoxConstraints(maxHeight: 45),
              contentPadding: EdgeInsetsDirectional.all(5),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: gray),
              ),
            ),
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                // _dropdownValue = value!;
              });
            },
            dropdownMenuEntries:
                _list.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(
                value: value,
                label: value,
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(5),
            color: bgSky,
            width: size.width * 0.85,
            child: const Center(
              child: Text(
                'Total leave credits: 5',
                style: TextStyle(color: darkGray),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
