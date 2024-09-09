import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/cancel_request_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/week_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ChangeRestdayForm extends StatefulWidget {
  const ChangeRestdayForm({super.key});

  @override
  State<ChangeRestdayForm> createState() => _ChangeRestdayFormState();
}

class _ChangeRestdayFormState extends State<ChangeRestdayForm> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  final AuthController _auth = Get.find<AuthController>();
  final ChangeRestdayController _changeRestday =
      Get.find<ChangeRestdayController>();
  final ChangeScheduleController _scheduleController =
      Get.find<ChangeScheduleController>();
  final TextEditingController _reason = TextEditingController();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final MultiSelectController _multiSelectController = MultiSelectController();
  final MessageController _messaging = Get.find<MessageController>();
  List<ValueItem> restdayList = [
    const ValueItem(label: "Sunday", value: "Sunday"),
    const ValueItem(label: "Monday", value: "Monday"),
    const ValueItem(label: "Tuesday", value: "Tuesday"),
    const ValueItem(label: "Wednesday", value: "Wednesday"),
    const ValueItem(label: "Thursday", value: "Thursday"),
    const ValueItem(label: "Friday", value: "Friday"),
    const ValueItem(label: "Saturday", value: "Saturday"),
  ];

  int transactionId = 0;

  String? dateError, restdayError, reasonError;
  bool isLoading = false;
  String? startDate, endDate;
  List attachments = [];
  late Size size;

  @override
  void initState() {
    _messaging.messagingType.value = "restday-request-chat";
    if (_changeRestday.transactionData['id'] != 0) {
      fillInValues(_changeRestday.transactionData['data']);
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   _changeRestday.transactionData.value = {"id": "0"};
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: size.height * .86,
      child: Obx(
        () => SelectedItemTabs(
          transactionLogs: _changeRestday.selectedTransactionLogs.value,
          pageCount: extraData != null ? 3 : 1,
          isLogsLoading: _changeRestday.isLogsLoading.value,
          status: extraData?['status'] ?? "",
          title: "Change Restday",
          detailPage: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const NumberLabel(label: "Select the date", number: 1),
                  const SizedBox(height: 15),
                  WeekInput(
                    onDateTimeChanged: (value) {
                      startDate = value?.start.toString().split(" ").first;
                      endDate = value?.end.toString().split(" ").first;
                      _transactionController.getDTROnDateRange(
                          startDate, endDate);
                      _scheduleController.fetchScheduleList(value);
                      setState(() {
                        dateError = null;
                      });
                    },
                  ),
                  // CustomDateInput(
                  //   type: "range",
                  //   fromDate: startDate,
                  //   toDate: endDate,
                  //   onDateTimeChanged: (value) {
                  //     startDate = value[0].toString().split(" ").first;
                  //     endDate = value[1].toString().split(" ").first;
                  //     _transactionController.getDTROnDateRange(
                  //         startDate, endDate);
                  //     _scheduleController.fetchScheduleList(value);
                  //     setState(() {
                  //       dateError = null;
                  //     });
                  //   },
                  //   error: dateError,
                  //   child: Container(),
                  // ),
                  const SizedBox(height: 15),
                  const NumberLabel(label: "Select new restday", number: 2),
                  const SizedBox(height: 15),
                  formField2(),
                  Visibility(
                    visible: restdayError != null,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          restdayError ?? "",
                          style: errorStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ReasonInput(
                    readOnly: false,
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
                    visible:
                        extraData == null || extraData['status'] == 'pending',
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
                                  builder: (context) => CancelRequestDialog(
                                    isLoading: isLoading,
                                    title: "Cancel DTR Correction Request",
                                    onPressed: () {
                                      if (_changeRestday.isLoading.isFalse) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _changeRestday.cancelRequest(
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
                          isLoading: _changeRestday.isSubmitting.value,
                          label: extraData != null ? "Update" : "Submit",
                          size: Size(size.width * .4, 40),
                          radius: 8,
                          bgColor: bgPrimaryBlue, //primaryBlue
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formField2() {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      width: size.width * .90,
      height: 50,
      child: MultiSelectDropDown(
        controller: _multiSelectController,
        onOptionSelected: (selectedOptions) {
          setState(() {
            restdayError = null;
          });
        },
        borderColor: gray,
        borderWidth: 1,
        hintColor: gray,
        borderRadius: 3,
        options: restdayList,
      ),
    );
  }

  Future<void> fillInValues(Map<String, dynamic>? data) async {
    if (data != null) {
      transactionId = data['id'];
      List newRestDays = data['new_rest_days'];

      _reason.text = data["reason"];
      startDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['start_date']));
      endDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['end_date']));
      attachments = data['attachments'] ?? [];

      _transactionController.getDTROnDateRange(startDate, endDate);
      _scheduleController.fetchScheduleList(
        DateTimeRange(
            start: DateTime.tryParse(startDate!)!,
            end: DateTime.tryParse(endDate!)!),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _multiSelectController.setOptions([
          const ValueItem(label: "Sunday", value: "Sunday"),
          const ValueItem(label: "Monday", value: "Monday"),
          const ValueItem(label: "Tuesday", value: "Tuesday"),
          const ValueItem(label: "Wednesday", value: "Wednesday"),
          const ValueItem(label: "Thursday", value: "Thursday"),
          const ValueItem(label: "Friday", value: "Friday"),
          const ValueItem(label: "Saturday", value: "Saturday"),
        ]);

        for (String restDay in newRestDays) {
          _multiSelectController.addSelectedOption(_multiSelectController
              .options
              .firstWhere((option) => option.value == restDay));
        }
      });
    }
  }

  void submitForm(bool isUpdate) {
    bool hasError = false;
    setState(() {
      if (_reason.text == "") {
        reasonError = 'This field is required.';
        hasError = true;
      }
      if (startDate == null) {
        dateError = 'This field is required.';
        hasError = true;
      }
      if (_multiSelectController.selectedOptions.isEmpty) {
        restdayError = 'This field is required.';
        hasError = true;
      }
    });

    if (hasError) {
      return;
    }
    List newRestDays = _multiSelectController.selectedOptions
        .map((item) => item.value)
        .toList();

    var data = {
      "id": isUpdate ? transactionId : null,
      "company_id": _auth.company.value.id,
      "employee_id": _auth.employee?.value.id,
      "start_date": startDate,
      "end_date": endDate,
      "new_rest_days": newRestDays,
      "current_rest_days":
          _transactionController.schedules.firstOrNull["rest_days"] ?? "Sunday",
      "schedule_id": null,
      "reason": _reason.text,
      "attachments": attachments,
    };

    if (isUpdate) {
      _changeRestday.updateRequestForm(data);
    } else {
      _changeRestday.sendRequest(data);
    }
  }
}
