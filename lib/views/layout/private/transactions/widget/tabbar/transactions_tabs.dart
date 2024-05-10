import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/approved_listview.dart';
import 'package:flutter/material.dart';

class TransactionsTabs extends StatefulWidget {
  const TransactionsTabs({
    super.key,
    required this.pendingList,
    required this.approvedList,
    required this.rejectedList,
    required this.cancelledList,
    this.isLoading = true,
  });

  final List<TransactionItem> pendingList;
  final List<TransactionItem> approvedList;
  final List<TransactionItem> rejectedList;
  final List<TransactionItem> cancelledList;
  final bool isLoading;

  @override
  State<TransactionsTabs> createState() => _TransactionsTabsState();
}

class _TransactionsTabsState extends State<TransactionsTabs>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    const Tab(text: "Pending"),
    const Tab(text: "Approved"),
    const Tab(text: "Rejected"),
    const Tab(text: "Cancelled"),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TransactionItem item = TransactionItem(
    id: 1,
    title: 'January 09, 2024',
    dateCreated: 'January 10, 2024',
    status: 'Pending',
    subtitle: 'Type: Clock in | Time: 09:20 am',
    type: 'DTR Correction',
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        TabBar(
          labelPadding: EdgeInsets.zero,
          indicatorPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          tabs: _tabs,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(color: bgPrimaryBlue, fontSize: 14),
          indicator: BoxDecoration(
            color: bgPrimaryBlue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 5),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.white,
          controller: _tabController,
        ),
        SizedBox(
          height: size.height * .5,
          child: TabBarView(
            controller: _tabController,
            children: [
              ApprovedListview(
                items: widget.pendingList,
                isLoading: widget.isLoading,
              ),
              ApprovedListview(
                items: widget.approvedList,
                isLoading: widget.isLoading,
              ),
              ApprovedListview(
                items: widget.rejectedList,
                isLoading: widget.isLoading,
              ),
              ApprovedListview(
                items: widget.cancelledList,
                isLoading: widget.isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
