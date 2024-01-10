import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/dtr_corrections.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/time_records.dart';
import 'package:ems_v4/views/widgets/buttons/transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        const Text(
          "Transactions",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: Get.height * .6,
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            crossAxisCount: 2,
            childAspectRatio: 1.25,
            children: [
              TransactionMenuButton(
                onPressed: () {
                  Get.to(() => const TimeRecords());
                  // Get.toNamed(
                  //   "/transactions/time_records",
                  //   id: _transactionController.routerKey,
                  // );
                  // _transactionController.pageIndex.value = 1;
                },
                title: "Time Records",
                child: const Center(
                  child: Icon(
                    Icons.calendar_month,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  Get.to(() => const DTRCorrection());
                  // Get.toNamed(
                  //   "/transactions/dtr_correction",
                  //   id: _transactionController.routerKey,
                  // );
                  // _transactionController.pageIndex.value = 2;
                },
                title: "DTR Corrections",
                child: const Center(
                  child: Icon(
                    Icons.edit_calendar_rounded,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {},
                title: "Leave",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/leave.svg",
                    height: 45,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {},
                title: "Overtime",
                child: const Center(
                  child: Icon(
                    Icons.more_time,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {},
                title: "Change Schedule",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/change_schedule.svg",
                    height: 50,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {},
                title: "Change Restday",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/change_restday.svg",
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
