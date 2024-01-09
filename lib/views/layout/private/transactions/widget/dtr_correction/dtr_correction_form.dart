import 'package:ems_v4/controller/transaction_controller.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/selected_item_tabs.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DTRCorrectionForm extends StatefulWidget {
  const DTRCorrectionForm({super.key});

  @override
  State<DTRCorrectionForm> createState() => _DTRCorrectionFormState();
}

class _DTRCorrectionFormState extends State<DTRCorrectionForm> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .86,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: Get.height * .86,
                child: SelectedItemTabs(
                  status: "Pending",
                  title: "DTR Correction",
                  detailPage: Column(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
