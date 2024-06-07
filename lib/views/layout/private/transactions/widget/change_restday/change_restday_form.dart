import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
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
  List<ValueItem> restdayList = [
    const ValueItem(label: "Sunday", value: "Sunday"),
    const ValueItem(label: "Monday", value: "Monday"),
    const ValueItem(label: "Tuesday", value: "Tuesday"),
    const ValueItem(label: "Wednesday", value: "Wednesday"),
    const ValueItem(label: "Thursday", value: "Thursday"),
    const ValueItem(label: "Friday", value: "Friday"),
    const ValueItem(label: "Saturday", value: "Saturday"),
  ];

  // String? _startTimeError, _totalHoursError;

  String? startDate, endDate;
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final Map<String, dynamic>? extraData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    fillInValues(extraData?['data']);
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
                  fromDate: startDate,
                  toDate: endDate,
                  onDateTimeChanged: (value) {
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
                ReasonInput(
                  readOnly: false,
                  controller: _reason,
                ),
                Obx(
                  () => Row(
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
                          List newRestDays = _multiSelectController
                              .selectedOptions
                              .map((item) => item.value)
                              .toList();

                          var data = {
                            "company_id": _auth.company.value.id,
                            "employee_id": _auth.employee?.value.id,
                            "start_date": startDate,
                            "end_date": endDate,
                            "new_rest_days": newRestDays,
                            "current_rest_days": _transactionController
                                .schedules.first["rest_days"],
                            "schedule_id": 1,
                            "reason": _reason.text,
                          };
                          _changeRestday.sendRequest(data);
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
    );
  }

  Widget formField2() {
    return Container(
        padding: const EdgeInsets.only(left: 25),
        width: size.width * .90,
        height: 50,
        child: MultiSelectDropDown(
          controller: _multiSelectController,
          onOptionSelected: (selectedOptions) {},
          borderColor: gray,
          borderWidth: 1,
          hintColor: gray,
          borderRadius: 3,
          options: restdayList,
        )
        // ListView.builder(
        //   padding: EdgeInsets.zero,
        //   scrollDirection: Axis.horizontal,
        //   itemCount: 7,
        //   itemBuilder: (context, index) {
        //     Map<String, dynamic> item = _changeRestday.days[index];

        //     return Row(
        //       children: [
        //         Checkbox(
        //           value: item["value"],
        //           onChanged: (value) {
        //             setState(() {
        //               item["value"] = value;
        //             });
        //           },
        //         ),
        //         Text(item["day"]),
        //       ],
        //     );
        //   },
        // ),
        );
  }

  Future<void> fillInValues(Map<String, dynamic>? data) async {
    if (data != null) {
      List newRestDays = data['new_rest_days'];

      _reason.text = data["reason"];
      startDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['start_date']));
      endDate = _dateTimeUtils.formatDate(
          dateTime: DateTime.tryParse(data['end_date']));

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
}
