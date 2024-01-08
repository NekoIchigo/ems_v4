import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:flutter/material.dart';

class TransactionsTabbar extends StatefulWidget {
  const TransactionsTabbar({super.key});

  @override
  State<TransactionsTabbar> createState() => _TransactionsTabbarState();
}

class _TransactionsTabbarState extends State<TransactionsTabbar>
    with SingleTickerProviderStateMixin {
  final List<Widget> tabs = [
    const TransactionsTabs(title: "Pending", isActive: true),
    const TransactionsTabs(title: "Approved", isActive: false),
    const TransactionsTabs(title: "Rejected", isActive: false),
    const TransactionsTabs(title: "Cancelled", isActive: false),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          padding: EdgeInsets.zero,
          tabs: tabs,
          controller: _tabController,
        ),
      ],
    );
  }
}
