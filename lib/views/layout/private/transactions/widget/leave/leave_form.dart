import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveForm extends StatefulWidget {
  const LeaveForm({super.key});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _leaveCount = TextEditingController();

  final AuthController _auth = Get.find<AuthController>();
  final LeaveController _leaveController = Get.find<LeaveController>();
  final TransactionController _transaction = Get.find<TransactionController>();

  String? startDate, endDate;

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
              pageCount: 1,
              title: "Leave",
              detailPage: SingleChildScrollView(
                child: Column(
                  children: [
                    const NumberLabel(label: "Select the date", number: 1),
                    CustomDateInput(
                      type: "range",
                      onDateTimeChanged: (value) {
                        startDate = value[0].toString().split(" ").first;
                        endDate = value[1].toString().split(" ").first;
                        _transaction.getDTROnDateRange(startDate, endDate);
                      },
                      child: Container(),
                    ),
                    const NumberLabel(
                      label: "Leave count(0.5 for half day)",
                      number: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _leaveCount,
                        style: defaultStyle,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Enter leave count",
                          hintStyle: defaultStyle,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: gray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: gray),
                          ),
                        ),
                      ),
                    ),
                    const NumberLabel(
                      label: "Leave details",
                      number: 3,
                    ),
                    formField2(),
                    ReasonInput(
                      readOnly: false,
                      controller: _reason,
                    ),
                    RoundedCustomButton(
                      onPressed: () {
                        var data = {
                          "company_id": _auth.company.value.id,
                          "employee_id": _auth.employee?.value.id,
                          "leave_count": _leaveCount.text,
                          "start_date": startDate,
                          "end_date": endDate,
                          "leave_type": "1",
                          "reason": _reason.text,
                        };
                        _leaveController.submitRequest(data);
                      },
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
          DropdownMenu(
            width: size.width * .84,
            textStyle: defaultStyle,
            hintText: "Select leave",
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
            onSelected: (value) {
              // This is called when the user selects an item.
              setState(() {
                // _dropdownValue = value!;
              });
            },
            dropdownMenuEntries:
                _leaveController.leaves.map<DropdownMenuEntry>((value) {
              return DropdownMenuEntry(
                value: value,
                label: value,
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: BoxDecoration(
              color: bgSky,
              borderRadius: BorderRadius.circular(5),
            ),
            width: size.width * 0.85,
            child: const Center(
              child: Text(
                'Total leave credits: 5',
                style: TextStyle(color: bgPrimaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
