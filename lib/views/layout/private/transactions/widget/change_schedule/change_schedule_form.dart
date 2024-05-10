import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeScheduleForm extends StatefulWidget {
  const ChangeScheduleForm({super.key});

  @override
  State<ChangeScheduleForm> createState() => _ChangeScheduleFormState();
}

class _ChangeScheduleFormState extends State<ChangeScheduleForm> {
  late Size size;

  List<bool> isSelected = [true, false];
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final ChangeScheduleController _scheduleController =
      Get.find<ChangeScheduleController>();

  String? dateStart, dateEnd, _startTimeError, _totalHoursError;

  @override
  void initState() {
    super.initState();
    _scheduleController.getScheduleByType("Fixed Schedule");
  }

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
              title: "Change Schedule",
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
                      ReasonInput(
                        readOnly: true,
                        controller: _reason,
                      ),
                      RoundedCustomButton(
                        onPressed: () {
                          var data = {
                            "start_date": dateStart,
                            "end_date": dateEnd,
                            "new_schedule": "",
                            "company_id": _auth.company.value.id,
                            "employee_id": _auth.employee?.value.id,
                            "reason": _reason.text,
                          };
                          _scheduleController.sendRequest(data);
                        },
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
              const Text(
                "Schedule Type",
                style: defaultStyle,
              ),
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
                        _scheduleController.getScheduleByType(
                          index == 0 ? "Fixed Schedule" : "Flexi Schedule",
                        );

                        isSelected[buttonIndex] = true;
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
          Obx(
            () => DropdownMenu(
              width: size.width * .84,
              textStyle: defaultStyle,
              hintText: "Select schedule",
              trailingIcon: _scheduleController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3,
                      ),
                    )
                  : null,
              enabled: _scheduleController.isLoading.isFalse,
              inputDecorationTheme: const InputDecorationTheme(
                constraints: BoxConstraints(maxHeight: 45),
                contentPadding: EdgeInsetsDirectional.all(5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: gray),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: gray),
                ),
              ),
              onSelected: (value) {
                setState(() {
                  // _dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  _scheduleController.schedules.map<DropdownMenuEntry>((value) {
                return DropdownMenuEntry(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
