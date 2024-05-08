import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/date_input.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:ems_v4/views/widgets/inputs/schedule_drt_.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeRestdayForm extends StatefulWidget {
  const ChangeRestdayForm({super.key});

  @override
  State<ChangeRestdayForm> createState() => _ChangeRestdayFormState();
}

class _ChangeRestdayFormState extends State<ChangeRestdayForm> {
  String attendanceDate = "";
  final TransactionController _controller = Get.find<TransactionController>();
  final TextEditingController _reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
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
                  readOnly: true,
                  controller: _reason,
                ),
                RoundedCustomButton(
                  onPressed: () {},
                  label: "Submit",
                  size: Size(size.width * .4, 40),
                  radius: 8,
                  bgColor: gray, //primaryBlue
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
              scheduleName: "",
              dtrRange: "",
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
