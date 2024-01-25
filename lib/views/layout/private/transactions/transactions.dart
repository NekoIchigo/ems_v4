import 'package:ems_v4/views/layout/private/transactions/widget/menu.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  // final TransactionController _transactionController =
  //     Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height * .78,
            child: const Center(
              child: Menu(),
              //   Navigator(
              //     key: Get.nestedKey(_transactionController.routerKey),
              //     onGenerateRoute: (settings) {
              //       return GetPageRoute(
              //         page: () => _transactionController
              //             .pages[_transactionController.pageIndex.value],
              //       );
              //     },
              //   ),
            ),
          ),
        ],
      ),
    );
  }
}
