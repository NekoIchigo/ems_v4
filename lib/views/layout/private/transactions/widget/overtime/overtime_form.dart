import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/schedule_drt_.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:ems_v4/views/widgets/inputs/timer_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class OvertimeForm extends StatefulWidget {
  const OvertimeForm({super.key});

  @override
  State<OvertimeForm> createState() => _OvertimeFormState();
}

class _OvertimeFormState extends State<OvertimeForm> {
  late Size size;
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  final AuthController _auth = Get.find<AuthController>();
  int transactionId = 0;

  final TextEditingController _reason = TextEditingController();
  final TextEditingController _totalHours = TextEditingController();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final OvertimeController _overtime = Get.find<OvertimeController>();
  String attendanceDate = "", timeStart = "";
  String? fromDate;
  // String? _dateError, _startTimeError, _totalHoursError;

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: size.height * .86,
              child: Obx(
                () => SelectedItemTabs(
                  pageCount: extraData != null ? 3 : 1,
                  transactionLogs: _overtime.selectedTransactionLogs.value,
                  isLogsLoading: _overtime.isLogsLoading.value,
                  status: extraData?['status'] ?? "",
                  title: "Overtime",
                  detailPage: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          const NumberLabel(
                              label: "Select the date", number: 1),
                          const SizedBox(height: 15),
                          CustomDateInput(
                            type: "single",
                            fromDate: fromDate,
                            onDateTimeChanged: (value) {
                              attendanceDate =
                                  value[0].toString().split(" ")[0];
                              _transactionController
                                  .getDTROnDate(attendanceDate);
                            },
                            child: Container(),
                          ),
                          const SizedBox(height: 15),
                          const SizedBox(height: 15),
                          const NumberLabel(
                              label: "Edit time record", number: 2),
                          const SizedBox(height: 15),
                          formField2(),
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
                                                if (_overtime
                                                    .isLoading.isFalse) {
                                                  _overtime.cancelRequest(
                                                    transactionId,
                                                    context,
                                                  );
                                                }
                                              },
                                              okText: _overtime.isLoading.isTrue
                                                  ? "Loading..."
                                                  : "Yes",
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
                                      "date_of_ot": attendanceDate,
                                      "time_start": timeStart,
                                      "no_of_hours": _dateTimeUtils
                                          .timeToDecimal(_totalHours.text),
                                      "company_id": _auth.company.value.id,
                                      "employee_id": _auth.employee?.value.id,
                                      "reason": _reason.text,
                                    };

                                    _overtime.submitRequest(data);
                                  },
                                  isLoading: _overtime.isSubmitting.isTrue,
                                  label: "Submit",
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
      ),
    );
  }

  Widget formField2() {
    return ColumnBuilder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(25, 0, 0, 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: gray),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Obx(
                () => ScheduleDTR(
                  isLoading: _transactionController.isLoading.isTrue,
                  scheduleName: _transactionController.scheduleName.value,
                  dtrRange: _transactionController.dtrRange.value,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * .55,
                    child: const Text(
                      'Overtime Start Time',
                      style: mediumStyle,
                    ),
                  ),
                  Expanded(
                    child: TimeInput(
                      value: timeStart,
                      selectedTime: (value) {
                        timeStart = _dateTimeUtils.time12to24(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * .55,
                    child: const Text(
                      'No. of Hours',
                      style: mediumStyle,
                    ),
                  ),
                  Expanded(
                    child: TimeTextField(controller: _totalHours),
                  )
                ],
              ),
            ],
          ),
        );
      },
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
      timeStart = _dateTimeUtils.formatTime(
        dateTime: DateTime.tryParse(data["start_time"]),
      );
      _totalHours.text =
          _dateTimeUtils.decimalToTime(double.parse(data['total_hours']));
      _transactionController.getDTROnDate(
        data['attendance_date'],
      );
    }
  }
}
