import 'package:ems_v4/views/widgets/coming_soon.dart';
import 'package:flutter/material.dart';

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
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * .78,
            child: const Center(
              child: ComingSoon(),
              // Menu(),
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
