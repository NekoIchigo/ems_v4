import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/views/widgets/buttons/transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TransactionMenu extends StatefulWidget {
  const TransactionMenu({super.key});

  @override
  State<TransactionMenu> createState() => _TransactionMenuState();
}

class _TransactionMenuState extends State<TransactionMenu> {
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();

  final List transactionItems = [
    {
      "title": "Time Records",
      "icon": const Icon(
        Icons.calendar_month,
        size: 50,
        color: bgPrimaryBlue,
      ),
      "path": "/time_records",
    },
    {
      "title": "DTR Corrections",
      "icon": const Icon(
        Icons.edit_calendar_rounded,
        size: 50,
        color: bgPrimaryBlue,
      ),
      "path": "/dtr_correction",
    },
    {
      "title": "Leave",
      "icon": SvgPicture.asset(
        "assets/svg/leave.svg",
        height: 45,
      ),
      "path": "/leave",
    },
    {
      "title": "Overtime",
      "icon": const Icon(
        Icons.more_time,
        size: 50,
        color: bgPrimaryBlue,
      ),
      "path": "/overtime",
    },
    {
      "title": "Change Schedule",
      "icon": SvgPicture.asset(
        "assets/svg/change_schedule.svg",
        height: 50,
      ),
      "path": "/change_schedule",
    },
    {
      "title": "Change Restday",
      "icon": SvgPicture.asset(
        "assets/svg/change_restday.svg",
        height: 50,
      ),
      "path": "/change_restday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
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
            height: size.height * .6,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
              ),
              itemCount: transactionItems.length,
              itemBuilder: (context, index) {
                String path = transactionItems[index]["path"];
                return TransactionMenuButton(
                  onPressed: () {
                    if (path == "/dtr_correction") {
                      _dtrCorrection.getAllDTR();
                    } else if (path == "/leave") {}
                    context.push(path);
                  },
                  title: transactionItems[index]["title"],
                  child: Center(
                    child: transactionItems[index]["icon"],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
