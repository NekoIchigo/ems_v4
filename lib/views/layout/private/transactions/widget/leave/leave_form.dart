import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/employee_leave.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/cancel_request_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  int transactionId = 0;
  bool isLoading = false;

  String? startDate,
      endDate,
      dateError,
      leaveCountError,
      leaveError,
      reasonError;

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
            child: Obx(
              () {
                bool hasCredits = _leaveController
                            .selectedLeave.value.employeeCredits !=
                        null ||
                    _leaveController.selectedLeave.value.employeeCredits != 0;
                return SelectedItemTabs(
                  status: extraData?['status'] ?? '',
                  pageCount: extraData != null ? 3 : 1,
                  transactionLogs:
                      _leaveController.selectedTransactionLogs.value,
                  isLogsLoading: _leaveController.isLogsLoading.value,
                  title: "Leave",
                  detailPage: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const NumberLabel(label: "Select the date", number: 1),
                        const SizedBox(height: 10),
                        CustomDateInput(
                          type: "range",
                          fromDate: startDate,
                          toDate: endDate,
                          error: dateError,
                          onDateTimeChanged: (value) {
                            startDate = value[0].toString().split(" ").first;
                            endDate = value[1].toString().split(" ").first;
                            final difference =
                                value[1]!.difference(value[0]!).inDays + 1;
                            _transaction.getDTROnDateRange(startDate, endDate);
                            setState(() {
                              _leaveCount.text = difference.toString();
                              dateError = null;
                            });
                          },
                          child: Container(),
                        ),
                        const SizedBox(height: 10),
                        const NumberLabel(
                          label: "Leave count(0.5 for half day)",
                          number: 2,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _leaveCount,
                            style: defaultStyle,
                            onChanged: (value) {
                              setState(() {
                                leaveCountError = null;
                              });
                            },
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
                        Visibility(
                          visible: leaveCountError != null,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                leaveCountError ?? "",
                                style: errorStyle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const NumberLabel(
                          label: "Leave details",
                          number: 3,
                        ),
                        const SizedBox(height: 10),
                        formField2(extraData),
                        ReasonInput(
                          readOnly: extraData?['status'] != 'pending',
                          controller: _reason,
                          number: 4,
                          error: reasonError,
                          onChanged: (value) {
                            setState(() {
                              reasonError = null;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: extraData?['status'] == 'pending' ||
                                  extraData?['status'] == 'approved',
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: RoundedCustomButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CancelRequestDialog(
                                        isLoading: isLoading,
                                        title: "Cancel Leave Request",
                                        onPressed: () {
                                          if (_leaveController
                                              .isLoading.isFalse) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _leaveController.cancelRequest(
                                              transactionId,
                                              context,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  label: "Cancel",
                                  radius: 8,
                                  size: Size(size.width * .4, 40),
                                  bgColor: gray,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: extraData == null ||
                                  extraData['status'] == 'pending',
                              child: RoundedCustomButton(
                                onPressed: () {
                                  if (extraData != null) {
                                    updateForm();
                                  } else {
                                    submitForm();
                                  }
                                },
                                disabled: !hasCredits,
                                label: extraData?['status'] == 'pending'
                                    ? "Update"
                                    : "Submit",
                                size: Size(size.width * .4, 40),
                                radius: 8,
                                isLoading: _leaveController.isSubmitting.isTrue,
                                bgColor: bgPrimaryBlue, //primaryBlue
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ]
                          .map((widget) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: widget,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
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
              visible: _leaveController.isLoading.isFalse,
              child: DropdownMenu<EmployeeLeave>(
                width: size.width * .84,
                textStyle: defaultStyle,
                hintText: "Select leave",
                trailingIcon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 25,
                ),
                initialSelection: extraData == null
                    ? null
                    : _leaveController.selectedLeave.value,
                inputDecorationTheme: const InputDecorationTheme(
                  constraints: BoxConstraints(maxHeight: 43),
                  contentPadding: EdgeInsetsDirectional.all(5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gray),
                  ),
                ),
                onSelected: (value) {
                  _leaveController.selectedLeave.value = value!;
                  setState(() {
                    leaveError = null;
                  });
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
              visible: leaveError != null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leaveError ?? "",
                  style: errorStyle,
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
      transactionId = data['id'];
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

  void submitForm() {
    bool hasError = false;
    EmployeeLeave employeeLeave = _leaveController.selectedLeave.value;
    setState(() {
      if (_reason.text == "") {
        reasonError = 'This field is required.';
        hasError = true;
      }
      if (startDate == null) {
        dateError = 'This field is required.';
        hasError = true;
      }
      if (_leaveCount.text == '') {
        leaveCountError = 'This field is required.';
        hasError = true;
      }

      if (_leaveController.selectedLeave.value.id == 0) {
        leaveError = 'This field is required.';
        hasError = true;
      }
    });

    if (hasError) {
      return;
    }

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
  }

  updateForm() {
    bool hasError = false;
    EmployeeLeave employeeLeave = _leaveController.selectedLeave.value;
    setState(() {
      if (_reason.text == "") {
        reasonError = 'This field is required.';
        hasError = true;
      }
      if (startDate == null) {
        dateError = 'This field is required.';
        hasError = true;
      }
      if (_leaveCount.text == '') {
        leaveCountError = 'This field is required.';
        hasError = true;
      }

      if (_leaveController.selectedLeave.value.id == 0) {
        leaveError = 'This field is required.';
        hasError = true;
      }
    });

    if (hasError) {
      return;
    }

    var data = {
      "id": transactionId,
      "company_id": _auth.company.value.id,
      "employee_id": _auth.employee?.value.id,
      "leave_count": _leaveCount.text,
      "start_date": startDate,
      "end_date": endDate,
      "leave_id": employeeLeave.leaveId,
      "reason": _reason.text,
    };
    _leaveController.updateRequestForm(data);
  }
}
