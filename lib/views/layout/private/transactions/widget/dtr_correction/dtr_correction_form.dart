import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/cancel_request_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
  late Size size;
  String attendanceDate = "";
  String? fromDate, dateError, timeChangeError, reasonError;
  int transactionId = 0;
  List attachments = [];

  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  final TransactionController _transactionController =
      Get.find<TransactionController>();
  final MessageController _messaging = Get.find<MessageController>();
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();
  int selectedScheduleId = 0;

  @override
  void initState() {
    _messaging.messagingType.value = "dtr-request-chat";
    if (_dtrCorrection.transactionData['id'] != 0) {
      fillInValues(_dtrCorrection.transactionData['data']);
    }

    super.initState();
  }

  // @override
  // void dispose() {
  //   _dtrCorrection.transactionData.value = {"id": "0"};
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    bool isLoading = false;
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
                status: extraData?['status'] ?? "",
                title: "DTR Correction",
                transactionLogs: _dtrCorrection.selectedTransactionLogs.value,
                isLogsLoading: _dtrCorrection.isLogsLoading.value,
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
                          fromDate: fromDate,
                          readOnly: fromDate != null,
                          onDateTimeChanged: (value) {
                            attendanceDate = value[0].toString().split(" ")[0];
                            _transactionController.getDTROnDate(attendanceDate);
                            setState(() {
                              dateError = "";
                            });
                          },
                          error: dateError,
                          child: Container(),
                        ),
                        const SizedBox(height: 15),
                        const NumberLabel(
                          label: "Select a Schedule",
                          number: 2,
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: DropdownMenu(
                            width: size.width * .84,
                            hintText: "-Select-",
                            textStyle: defaultStyle,
                            inputDecorationTheme: InputDecorationTheme(
                              isDense: true,
                              errorMaxLines: 1,
                              constraints: BoxConstraints.tight(
                                const Size.fromHeight(40),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintStyle: hintStyle,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: gray300),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: gray300),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: colorError),
                              ),
                            ),
                            onSelected: (value) {
                              selectedScheduleId = value ?? 0;
                              _transactionController.getDTRBySchedule(
                                  selectedScheduleId, attendanceDate);
                              setState(() {});
                            },
                            menuStyle: const MenuStyle(
                              surfaceTintColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                            ),
                            dropdownMenuEntries: _transactionController
                                .schedules
                                .map<DropdownMenuEntry>((value) {
                              return DropdownMenuEntry(
                                value: value['id'],
                                label: value['name'] ?? value['sub_name'],
                                labelWidget: Text(
                                  value['name'] ?? value['sub_name'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                style: const ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(primaryBlue),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const NumberLabel(label: "Edit time record", number: 3),
                        const SizedBox(height: 15),
                        formField2(),
                        Visibility(
                          visible: timeChangeError != null,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                timeChangeError ?? "",
                                style: errorStyle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Visibility(
                          visible: false,
                          child: formField2(),
                        ),
                        const SizedBox(height: 15),
                        ReasonInput(
                          number: 4,
                          readOnly: false,
                          controller: _reason,
                          error: reasonError,
                          onChanged: (value) {
                            setState(() {
                              reasonError = "";
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
                                          title: "Cancel DTR Correction",
                                          subTitle:
                                              "Are you sure you want to cancel your DTR Correction request?\n This action cannot be undone.",
                                          onPressed: () {
                                            if (_dtrCorrection
                                                .isLoading.isFalse) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              _dtrCorrection.cancelRequest(
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
                                isLoading: _dtrCorrection.isSubmitting.value,
                                label: extraData != null ? "Update" : "Submit",
                                size: Size(size.width * .4, 40),
                                radius: 8,
                                bgColor: bgPrimaryBlue,
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

  Widget formField2() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(left: 25),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            _transactionController.isLoading.isTrue
                ? const CustomLoader(height: 35)
                : Row(
                    children: [
                      const SizedBox(
                        width: 35,
                        child: Text("DTR", style: defaultStyle),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: gray100,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _transactionController.dtrRange.value,
                            overflow: TextOverflow.ellipsis,
                            style: defaultStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray300),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      "Clock In",
                      style: defaultStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: _transactionController.isLoading.isTrue
                      ? const CustomLoader(height: 35)
                      : TimeInput(
                          value: _transactionController.clockInAt.value,
                          selectedTime: (value) async {
                            _transactionController.clockInAt.value =
                                _dateTimeUtils.time12to24(value);
                            setState(() {
                              timeChangeError = null;
                            });
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray300),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      "Clock Out",
                      style: defaultStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: _transactionController.isLoading.isTrue
                      ? const CustomLoader(height: 35)
                      : TimeInput(
                          value: _transactionController.clockOutAt.value,
                          selectedTime: (value) async {
                            _transactionController.clockOutAt.value =
                                _dateTimeUtils.time12to24(value);
                            setState(() {
                              timeChangeError = null;
                            });
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void fillInValues(Map<String, dynamic>? data) {
    _transactionController.scheduleName.value = "Schedule name";
    _transactionController.dtrRange.value = "00:00 to 00:00";

    if (data != null) {
      transactionId = data['id'];
      _reason.text = data["reason"] ?? "";
      fromDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['attendance_date']));
      _transactionController.clockInAt.value = _dateTimeUtils.formatTime(
        dateTime: DateTime.tryParse(data["clock_in_at"]),
      );
      attendanceDate = fromDate ?? "";
      _transactionController.clockOutAt.value = _dateTimeUtils.formatTime(
        dateTime: DateTime.tryParse(data["clock_out_at"]),
      );

      _transactionController.getDTROnDate(
        data['attendance_date'],
      );
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
      if (attendanceDate == "") {
        dateError = 'This field is required.';
        hasError = true;
      }
      if (_transactionController.clockInAt.value == "00:00" &&
          _transactionController.clockOutAt.value == "00:00") {
        timeChangeError = 'There must be a changes in this field';
        hasError = true;
      }
    });

    if (hasError) {
      return;
    }

    var data = {
      "id": isUpdate ? transactionId : null,
      "reason": _reason.text,
      "company_id": _auth.company.value.id,
      "date_of_correction": attendanceDate,
      "employee_id": _auth.employee?.value.id,
      "time_of_record": [
        {
          "schedule_id": _transactionController.schedules.firstOrNull["id"],
          "attendance_date": attendanceDate,
          "attendance_record_id": null,
          "clock_in": _transactionController.clockInAt.value,
          "clock_out": _transactionController.clockOutAt.value,
          "reason": _reason.text,
        }
      ],
      "attachments": attachments,
    };

    if (isUpdate) {
      _dtrCorrection.updateRequestForm(data);
    } else {
      _dtrCorrection.submitRequest(data);
    }
  }
}
