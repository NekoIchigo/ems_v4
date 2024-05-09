import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/schedule_drt_.dart';
import 'package:ems_v4/views/widgets/inputs/time_input.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
  late Size size;
  String _clockin = "--:-- --", _clockout = "--:-- --";
  String attendanceDate = "";

  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  final TransactionController _controller = Get.find<TransactionController>();
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();

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
              title: "DTR Correction",
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
                          _controller.getDTROnDate(attendanceDate);
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
                      Obx(
                        () => RoundedCustomButton(
                          onPressed: () {
                            var data = {
                              "date_of_correction": attendanceDate,
                              "employee_id": _auth.employee?.value.id,
                              "reason": _reason.text,
                              "company_id": _auth.company.value.id,
                              "time_of_record": [
                                {
                                  "company_id": _auth.company.value.id,
                                  "employee_id": _auth.employee?.value.id,
                                  "schedule_id":
                                      _controller.schedules.first["id"],
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
                          label: "Submit",
                          size: Size(size.width * .4, 40),
                          radius: 8,
                          bgColor: gray, //primaryBlue
                        ),
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
              isLoading: _controller.isLoading.value,
              scheduleName: _controller.scheduleName.value,
              dtrRange: _controller.dtrRange.value,
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
                  child: _controller.isLoading.isTrue
                      ? const CustomLoader(height: 35)
                      : TimeInput(
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
                  child: _controller.isLoading.isTrue
                      ? const CustomLoader(height: 35)
                      : TimeInput(
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
}
