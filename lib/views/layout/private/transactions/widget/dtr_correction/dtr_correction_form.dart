import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/schedule_drt_.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
  late Size size;
  String _clockin = "--:-- --", _clockout = "--:-- --", attendanceDate = "";
  String? fromDate;
  int transactionId = 0;

  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  final TransactionController _transactionController =
      Get.find<TransactionController>();
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();

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
                          },
                          child: Container(),
                        ),
                        const SizedBox(height: 15),
                        const NumberLabel(label: "Edit time record", number: 2),
                        const SizedBox(height: 15),
                        formField2(),
                        const SizedBox(height: 15),
                        Visibility(
                          visible: false,
                          child: formField2(),
                        ),
                        const SizedBox(height: 15),
                        ReasonInput(
                          readOnly: false,
                          controller: _reason,
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
                                            okPress: () {
                                              _dtrCorrection.cancelRequest(
                                                  transactionId, context);
                                            },
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
                                onPressed: () async {
                                  var data = {
                                    "reason": _reason.text,
                                    "company_id": _auth.company.value.id,
                                    "date_of_correction": attendanceDate,
                                    "employee_id": _auth.employee?.value.id,
                                    "time_of_record": [
                                      {
                                        "schedule_id": _transactionController
                                            .schedules.first["id"],
                                        "attendance_date": attendanceDate,
                                        "attendance_record_id": null,
                                        "clock_in": _clockin,
                                        "clock_out": _clockout,
                                        "reason": _reason.text,
                                      }
                                    ],
                                  };
                                  _dtrCorrection.submitRequest(data);
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
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            ScheduleDTR(
              isLoading: _transactionController.isLoading.value,
              scheduleName: _transactionController.scheduleName.value,
              dtrRange: _transactionController.dtrRange.value,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray),
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
                          value: _clockin,
                          selectedTime: (value) async {
                            _clockin = _dateTimeUtils.time12to24(value);
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
                      border: Border.all(color: gray),
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
                          value: _clockout,
                          selectedTime: (value) async {
                            _clockout = _dateTimeUtils.time12to24(value);
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
      _reason.text = data["reason"];
      fromDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['attendance_date']));
      _clockin = _dateTimeUtils.formatTime(
        dateTime: DateTime.tryParse(data["clock_in_at"]),
      );

      _clockout = _dateTimeUtils.formatTime(
        dateTime: DateTime.tryParse(data["clock_out_at"]),
      );

      _transactionController.getDTROnDate(
        data['attendance_date'],
      );
    }
  }
}
