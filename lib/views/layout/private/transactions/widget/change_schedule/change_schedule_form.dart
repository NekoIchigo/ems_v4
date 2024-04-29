import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';

class ChangeScheduleForm extends StatefulWidget {
  const ChangeScheduleForm({super.key});

  @override
  State<ChangeScheduleForm> createState() => _ChangeScheduleFormState();
}

class _ChangeScheduleFormState extends State<ChangeScheduleForm> {
  late Size size;
  final List<String> _list = <String>[
    'Schedule Type 1',
    'Schedule Type 2',
    'Schedule Type 3',
  ];
  List<bool> isSelected = [true, false];
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
                        type: "range",
                        onDateTimeChanged: (value) {
                          print(value);
                        },
                        child: Container(),
                      ),
                      const SizedBox(height: 15),
                      const NumberLabel(
                          label: "Change schedule details", number: 2),
                      const SizedBox(height: 15),
                      formField2(),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: false,
                        child: formField2(),
                      ),
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
      padding: const EdgeInsets.only(left: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Schedule Type"),
              ToggleButtons(
                isSelected: isSelected,
                constraints: BoxConstraints.tight(Size(size.width * .2, 25)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                borderRadius: BorderRadius.circular(10),
                color: gray,
                selectedColor: Colors.white,
                borderColor: primaryBlue,
                selectedBorderColor: primaryBlue,
                fillColor: primaryBlue,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = !isSelected[buttonIndex];
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                children: const <Widget>[
                  Text("Fixed"),
                  Text("Flexi"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownMenu<String>(
            initialSelection: _list.first,
            width: size.width * .84,
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
        ],
      ),
    );
  }
}
