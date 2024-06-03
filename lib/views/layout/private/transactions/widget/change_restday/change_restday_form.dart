import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  // String? _startTimeError, _totalHoursError;

  String? startDate, endDate;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: size.height * .86,
      child: SelectedItemTabs(
        pageCount: 1,
        status: "",
        title: "Change Restday",
        detailPage: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                const NumberLabel(label: "Select the date", number: 1),
                const SizedBox(height: 15),
                CustomDateInput(
                  type: "range",
                  onDateTimeChanged: (value) {
                    print(value);
                    startDate = value[0].toString().split(" ").first;
                    endDate = value[1].toString().split(" ").first;
                    _transactionController.getDTROnDateRange(
                        startDate, endDate);
                    _scheduleController.fetchScheduleList(value);
                  },
                  child: Container(),
                ),
                const SizedBox(height: 15),
                const NumberLabel(label: "Select new restday", number: 2),
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
                      List newRestDays = _changeRestday.days
                          .where((day) => day["value"])
                          .map((day) => day["name"])
                          .toList();

                      var data = {
                        "company_id": _auth.company.value.id,
                        "employee_id": _auth.employee?.value.id,
                        "start_date": startDate,
                        "end_date": endDate,
                        "new_rest_days": newRestDays,
                        "current_rest_days":
                            _transactionController.schedules.first["rest_days"],
                        "schedule_id": 1,
                        "reason": _reason.text,
                      };
                      _changeRestday.sendRequest(data);
                    },
                    isLoading: _changeRestday.isSubmitting.value,
                    label: "Submit",
                    size: Size(size.width * .4, 40),
                    radius: 8,
                    bgColor: gray, //primaryBlue
                  ),
                ),
                const SizedBox(height: 60),
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
    );
  }

  Widget formField2() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: size.width * .90,
      height: 50,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = _changeRestday.days[index];

          return Row(
            children: [
              Checkbox(
                value: item["value"],
                onChanged: (value) {
                  setState(() {
                    item["value"] = value;
                  });
                },
              ),
              Text(item["day"]),
            ],
          );
        },
      ),
    );
  }
}
