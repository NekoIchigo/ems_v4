import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/employee_leave.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LeaveForm extends StatefulWidget {
  const LeaveForm({super.key});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _leaveCount = TextEditingController();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  final AuthController _auth = Get.find<AuthController>();
  final LeaveController _leaveController = Get.find<LeaveController>();
  final TransactionController _transaction = Get.find<TransactionController>();

  String? startDate, endDate;

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final Map<String, dynamic>? extraData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    fillInValues(extraData?['data']);

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
              pageCount: extraData != null ? 3 : 1,
              title: "Leave",
              detailPage: SingleChildScrollView(
                child: Column(
                  children: [
                    const NumberLabel(label: "Select the date", number: 1),
                    CustomDateInput(
                      type: "range",
                      fromDate: startDate,
                      toDate: endDate,
                      onDateTimeChanged: (value) {
                        startDate = value[0].toString().split(" ").first;
                        endDate = value[1].toString().split(" ").first;
                        final difference =
                            value[1]!.difference(value[0]!).inDays + 1;
                        _transaction.getDTROnDateRange(startDate, endDate);
                        setState(() {
                          _leaveCount.text = difference.toString();
                        });
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
                    formField2(extraData),
                    ReasonInput(
                      readOnly: false,
                      controller: _reason,
                      number: 4,
                    ),
                    Obx(
                      () {
                        EmployeeLeave employeeLeave =
                            _leaveController.selectedLeave.value;
                        bool hasCredits = _leaveController
                                    .selectedLeave.value.employeeCredits !=
                                null ||
                            _leaveController
                                    .selectedLeave.value.employeeCredits !=
                                0;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: extraData != null,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: RoundedCustomButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return GemsDialog(
                                          title: "Cancel Request",
                                          hasMessage: true,
                                          withCloseButton: true,
                                          hasCustomWidget: false,
                                          message:
                                              "Are you sure you want to cancel your request ?",
                                          type: "question",
                                          cancelPress: () {
                                            Navigator.of(context).pop();
                                          },
                                          okPress: () {},
                                          okText: "Yes",
                                          okButtonBGColor: bgPrimaryBlue,
                                          buttonNumber: 2,
                                        );
                                      },
                                    );
                                  },
                                  label: "Cancel",
                                  radius: 8,
                                  size: Size(size.width * .4, 40),
                                  bgColor: gray,
                                ),
                              ),
                            ),
                            RoundedCustomButton(
                              onPressed: () {
                                var data = {
                                  "company_id": _auth.company.value.id,
                                  "employee_id": _auth.employee?.value.id,
                                  "leave_count": _leaveCount.text,
                                  "start_date": startDate,
                                  "end_date": endDate,
                                  "leave_type": employeeLeave.leaveId,
                                  "reason": _reason.text,
                                };
                                _leaveController.submitRequest(data);
                              },
                              disabled: !hasCredits,
                              label: "Submit",
                              size: Size(size.width * .4, 40),
                              radius: 8,
                              isLoading: _leaveController.isSubmitting.isTrue,
                              bgColor: bgPrimaryBlue, //primaryBlue
                            ),
                          ],
                        );
                      },
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

  Widget formField2(extraData) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Obx(
        () => Column(
          children: [
            Visibility(
              visible: _leaveController.isLoading.isFalse && extraData == null,
              child: DropdownMenu<EmployeeLeave>(
                width: size.width * .84,
                textStyle: defaultStyle,
                hintText: "Select leave",
                trailingIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 25,
                ),
                initialSelection: null,
                inputDecorationTheme: const InputDecorationTheme(
                  constraints: BoxConstraints(maxHeight: 45),
                  contentPadding: EdgeInsetsDirectional.all(5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gray),
                  ),
                ),
                onSelected: (value) {
                  _leaveController.selectedLeave.value = value!;
                },
                dropdownMenuEntries: _leaveController.leaves
                    .map<DropdownMenuEntry<EmployeeLeave>>((value) {
                  return DropdownMenuEntry<EmployeeLeave>(
                    value: value,
                    label: value.name ?? "",
                  );
                }).toList(),
              ),
            ),
            Visibility(
              visible: _leaveController.isLoading.isFalse && extraData != null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                width: size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: gray),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _leaveController.selectedLeave.value.name ?? "",
                  style: const TextStyle(color: gray),
                ),
              ),
            ),
            Visibility(
              visible: _leaveController.isLoading.isTrue,
              child: CustomLoader(
                height: 40,
                width: size.width,
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _leaveController.selectedLeave.value.id != 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  color: bgSky,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: size.width * 0.85,
                child: Center(
                  child: Text(
                    "Total leave credits: ${_leaveController.selectedLeave.value.employeeCredits}",
                    style: const TextStyle(color: bgPrimaryBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fillInValues(Map<String, dynamic>? data) async {
    if (data != null) {
      _reason.text = data["reason"];
      startDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['start_date']));
      endDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['end_date']));
      _leaveCount.text = data['leave_count'].toString();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _leaveController.getAvailableLeave(data['leave_id']);
      });
    }
  }
}
