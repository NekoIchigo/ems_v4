import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/schedule.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeScheduleForm extends StatefulWidget {
  const ChangeScheduleForm({super.key});

  @override
  State<ChangeScheduleForm> createState() => _ChangeScheduleFormState();
}

class _ChangeScheduleFormState extends State<ChangeScheduleForm> {
  late Size size;

  List<bool> isSelected = [true, false];
  final TextEditingController _reason = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();
  final ChangeScheduleController _scheduleController =
      Get.find<ChangeScheduleController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  String? dateStart, dateEnd;

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
            child: SelectedItemTabs(
              pageCount: extraData != null ? 3 : 1,
              transactionLogs:
                  _scheduleController.selectedTransactionLogs.value,
              isLogsLoading: _scheduleController.isLogsLoading.value,
              status: "",
              title: "Change Schedule",
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
                        fromDate: dateStart,
                        toDate: dateEnd,
                        onDateTimeChanged: (value) {
                          dateStart = value[0].toString().split(" ")[0];
                          dateEnd = value[1].toString().split(" ")[0];
                          _scheduleController.fetchScheduleList(value);
                        },
                        child: Container(),
                      ),
                      const SizedBox(height: 15),
                      const NumberLabel(
                          label: "Change schedule details", number: 2),
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
                                var data = {
                                  "start_date": dateStart,
                                  "end_date": dateEnd,
                                  "current_schedule_id": 1,
                                  "new_schedule": _scheduleController
                                      .selectedSchedule.value.id,
                                  "company_id": _auth.company.value.id,
                                  "employee_id": _auth.employee?.value.id,
                                  "reason": _reason.text,
                                };
                                _scheduleController.sendRequest(data);
                              },
                              isLoading: _scheduleController.isSubmitting.value,
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
        ],
      ),
    );
  }

  Widget formField2() {
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

                        _scheduleController.getScheduleByType(
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
              textStyle: defaultStyle,
              hintText: "Select schedule",
              initialSelection:
                  _scheduleController.selectedSchedule.value.id == 0
                      ? null
                      : _scheduleController.selectedSchedule.value,
              trailingIcon: _scheduleController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3,
                      ),
                    )
                  : null,
              enabled: _scheduleController.isLoading.isFalse,
              inputDecorationTheme: const InputDecorationTheme(
                constraints: BoxConstraints(maxHeight: 45),
                contentPadding: EdgeInsetsDirectional.all(5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: gray),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: gray),
                ),
              ),
              onSelected: (value) {
                setState(() {
                  _scheduleController.selectedSchedule.value = value!;
                });
              },
              dropdownMenuEntries: _scheduleController.schedules
                  .map<DropdownMenuEntry<Schedule>>((value) {
                return DropdownMenuEntry(
                  value: value,
                  label: value.name,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void fillInValues(Map<String, dynamic>? data) {
    if (data != null) {
      _reason.text = data["reason"];
      dateStart = _dateTimeUtils.formatDate(
        dateTime: DateTime.tryParse(
          data['start_date'],
        ),
      );
      dateEnd = _dateTimeUtils.formatDate(
        dateTime: DateTime.tryParse(
          data['end_date'],
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleController.getScheduleByType(
          "Fixed Schedule",
          data['new_schedule_id'],
        );
      });
    }
  }
}
