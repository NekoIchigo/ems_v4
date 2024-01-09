import 'package:ems_v4/global/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: Get.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 15,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Get.back();
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
                bottom: 100,
                right: 10,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: bgPrimaryBlue,
                  onPressed: () {},
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
      ),
    );
  }
}
