import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/schedule_drt_.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:ems_v4/views/widgets/inputs/timer_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final TextEditingController _reason = TextEditingController();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final OvertimeController _overtime = Get.find<OvertimeController>();
  String attendanceDate = "", timeStart = "";

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

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
              child: SelectedItemTabs(
                title: "Overtime",
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
                          onDateTimeChanged: (value) {
                            attendanceDate = value[0].toString().split(" ")[0];
                            _transactionController.getDTROnDate(attendanceDate);
                            print(attendanceDate);
                          },
                          child: Container(),
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 15),
                        const NumberLabel(label: "Edit time record", number: 2),
                        const SizedBox(height: 15),
                        formField2(),
                        const SizedBox(height: 15),
                        ReasonInput(
                          readOnly: false,
                          controller: _reason,
                        ),
                        Obx(
                          () => RoundedCustomButton(
                            onPressed: () {
                              var data = {
                                "date_of_ot": attendanceDate,
                                "time_start": timeStart,
                                "no_of_hours": "1.5",
                                "company_id": _auth.company.value.id,
                                "employee_id": _auth.employee?.value.id,
                                "reason": _reason.text,
                              };

                              print(data);
                              _overtime.submitRequest(data);
                            },
                            isLoading: _overtime.isSubmitting.isTrue,
                            label: "Submit",
                            size: Size(size.width * .4, 40),
                            radius: 8,
                            bgColor: gray, //primaryBlue
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
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
                  const Expanded(
                    child: TimeTextField(),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
