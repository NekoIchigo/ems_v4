import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height * .78,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Transactions",
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .6,
                    child: GridView.count(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      crossAxisCount: 2,
                      children: [
                        TransactionMenuButton(
                          onPressed: () {
                            Get.toNamed('/transactions/time_records');
                          },
                          child: const Center(
                            child: Icon(
                              Icons.calendar_month,
                              size: 60,
                              color: bgPrimaryBlue,
                            ),
                          ),
                        ),
                        TransactionMenuButton(
                          onPressed: () {},
                          child: const Center(
                            child: Icon(
                              Icons.edit_calendar_rounded,
                              size: 60,
                              color: bgPrimaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
