import 'package:ems_v4/views/layout/private/transactions/widget/dtr_correction/dtr_corrections.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/menu.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/time_records/time_records.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxInt pageIndex = 0.obs;
  final int routerKey = 3;
  final List<Widget> pages = [
    const TransactionMenu(),
    const TimeRecords(),
    const DTRCorrection(),
  ];
}
