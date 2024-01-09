import 'package:ems_v4/views/layout/private/transactions/transaction_menu.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/dtr_corrections.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/time_records.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final int routerKey = 2;

  final List<Widget> pages = [
    const TransactionMenu(),
    const TimeRecords(),
    const DTRCorrection(),
  ];
}
