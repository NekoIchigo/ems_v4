import 'package:ems_v4/controller/transaction_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/dtr_correction/dtr_correction_form.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DTRCorrection extends StatefulWidget {
  const DTRCorrection({super.key});

  @override
  State<DTRCorrection> createState() => _DTRCorrectionState();
}

class _DTRCorrectionState extends State<DTRCorrection> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Get.back();
                  // Get.back(id: _transactionController.routerKey);
                  // _transactionController.pageIndex.value = 0;
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    "DTR Correction",
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MonthFilterDropdown(
                  onChanged: (p0) {},
                ),
                const TransactionsTabs(),
              ],
            ),
            Positioned(
              bottom: 25,
              right: 10,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: bgPrimaryBlue,
                onPressed: () {
                  Get.to(() => const DTRCorrectionForm());
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}