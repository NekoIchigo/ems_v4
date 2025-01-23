import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/add_shift_controller.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/schedule.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/cancel_request_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AddShiftForm extends StatefulWidget {
  const AddShiftForm({super.key});

  @override
  State<AddShiftForm> createState() => _AddShiftFormState();
}

class _AddShiftFormState extends State<AddShiftForm> {
  late Size size;

  List<bool> isSelected = [true, false];
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final AddShiftController _addShiftController = Get.find<AddShiftController>();
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  int transactionId = 0;
  bool isLoading = false;
  List attachments = [];

  String? dateStart, dateEnd, dateError, scheduleError, reasonError;

  @override
  void initState() {
    if (_addShiftController.transactionData['id'] != 0) {
      fillInValues(_addShiftController.transactionData['data']);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addShiftController.getScheduleByType(
        "Fixed Schedule",
        _addShiftController.transactionData['data'] != null
            ? _addShiftController.transactionData['data']['schedule_id']
            : null,
      );
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   _addShiftController.transactionData.value = {"id": "0"};
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final Map<String, dynamic>? extraData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

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
              () => SelectedItemTabs(
                pageCount: extraData != null ? 3 : 1,
                transactionLogs:
                    _addShiftController.selectedTransactionLogs.value,
                isLogsLoading: _addShiftController.isLogsLoading.value,
                status: "",
                title: "Add New Schedule",
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
                          fromDate: dateStart,
                          readOnly: extraData?['status'] != 'pending' &&
                              extraData != null,
                          onDateTimeChanged: (value) {
                            dateStart = value[0].toString().split(" ")[0];
                            _transactionController.getSingleSchedule(dateStart);
                            setState(() {
                              dateError = null;
                            });
                            // _addShiftController.fetchScheduleList(
                            //   DateTimeRange(
                            //       start: DateTime.parse(dateStart!),
                            //       end: DateTime.parse(dateEnd!)),
                            // );
                            setState(() {
                              dateError = null;
                            });
                          },
                          error: dateError,
                          child: Container(),
                        ),
                        const SizedBox(height: 15),
                        const NumberLabel(
                            label: "Change schedule details", number: 2),
                        const SizedBox(height: 15),
                        formField2(extraData),
                        const SizedBox(height: 15),
                        ReasonInput(
                          readOnly: extraData?['status'] != 'pending' &&
                              extraData != null,
                          controller: _reason,
                          error: reasonError,
                          onChanged: (value) {
                            setState(() {
                              reasonError = null;
                            });
                          },
                          attachments: attachments,
                          onSelectFile: (files) {
                            setState(() {
                              attachments = files;
                            });
                          },
                        ),
                        Visibility(
                          visible: extraData == null ||
                              extraData['status'] == 'pending',
                          child: Row(
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
                                        builder: (context) =>
                                            CancelRequestDialog(
                                          isLoading: isLoading,
                                          title: "Cancel Change Schedule",
                                          subTitle:
                                              "Are you sure you want to cancel your change schedule request?\n This action cannot be undone.",
                                          onPressed: () {
                                            if (_addShiftController
                                                .isLoading.isFalse) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              _addShiftController.cancelRequest(
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
                              RoundedCustomButton(
                                onPressed: () {
                                  submitForm(extraData != null);
                                },
                                isLoading:
                                    _addShiftController.isSubmitting.value,
                                label: extraData != null ? "Update" : "Submit",
                                size: Size(size.width * .4, 40),
                                radius: 8,
                                bgColor: bgPrimaryBlue, //primaryBlue
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formField2(extraData) {
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
                        isSelected[buttonIndex] = true;
                        _addShiftController.getScheduleByType(
                          index == 0 ? "Fixed Schedule" : "Flexi Schedule",
                          null,
                        );
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
            () => DropdownMenu<Schedule>(
              width: size.width * .84,
              menuHeight: size.height * .2,
              textStyle: defaultStyle,
              hintText: "Select schedule",
              initialSelection:
                  _addShiftController.selectedSchedule.value.id == 0
                      ? null
                      : _addShiftController.selectedSchedule.value,
              trailingIcon: _addShiftController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3,
                      ),
                    )
                  : null,
              enabled: _addShiftController.isLoading.isFalse ||
                  (extraData?['status'] != 'pending' && extraData != null),
              inputDecorationTheme: InputDecorationTheme(
                constraints: const BoxConstraints(maxHeight: 45),
                filled: true,
                fillColor:
                    extraData?['status'] != 'pending' && extraData != null
                        ? gray100
                        : Colors.white,
                contentPadding: const EdgeInsetsDirectional.all(5),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: gray300),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: gray300),
                ),
              ),
              onSelected: (value) {
                setState(() {
                  _addShiftController.selectedSchedule.value = value!;
                  scheduleError = null;
                });
              },
              dropdownMenuEntries: _addShiftController.schedules
                  .map<DropdownMenuEntry<Schedule>>((value) {
                return DropdownMenuEntry(
                  value: value,
                  label: value.name,
                );
              }).toList(),
            ),
          ),
          Visibility(
            visible: scheduleError != null,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                scheduleError ?? "",
                style: errorStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fillInValues(Map<String, dynamic>? data) {
    if (data != null) {
      transactionId = data['id'];

      dateStart = _dateTimeUtils.formatDate(
        dateTime: DateTime.tryParse(
          data['attendance_date'],
        ),
      );
      // dateEnd = _dateTimeUtils.formatDate(
      //   dateTime: DateTime.tryParse(
      //     data['end_date'],
      //   ),
      // );
      _reason.text = data["reason"] ?? "";
      attachments = data['attachments'] ?? [];
    }
  }

  void submitForm(bool isUpdate) {
    bool hasError = false;

    setState(() {
      if (_reason.text == "") {
        reasonError = 'This field is required.';
        hasError = true;
      }
      if (dateStart == null) {
        dateError = 'This field is required.';
        hasError = true;
      }
      if (_addShiftController.selectedSchedule.value.id == 0) {
        scheduleError = 'This field is required.';
        hasError = true;
      }
    });

    if (hasError) {
      return;
    }
    var data = {
      "id": isUpdate ? transactionId : null,
      "attendance_date": dateStart,
      // "end_date": dateEnd,
      // "current_schedule_id": _addShiftController.currentScheduleId.value,
      "schedule_id": _addShiftController.selectedSchedule.value.id,
      "company_id": _auth.company.value.id,
      "employee_id": _auth.employee?.value.id,
      "reason": _reason.text,
      "attachments": attachments,
    };

    if (isUpdate) {
      _addShiftController.updateRequestForm(data);
    } else {
      _addShiftController.sendRequest(data);
    }
  }
}
