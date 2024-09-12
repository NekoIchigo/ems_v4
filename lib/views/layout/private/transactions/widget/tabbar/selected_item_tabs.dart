import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/logs_tab.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/message_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SelectedItemTabs extends StatefulWidget {
  final String? status;
  final String title;
  final Widget detailPage;
  final int pageCount;
  final TransactionLogs? transactionLogs;
  final bool isLogsLoading;
  const SelectedItemTabs({
    super.key,
    this.status,
    required this.title,
    required this.detailPage,
    required this.pageCount,
    this.transactionLogs,
    required this.isLogsLoading,
  });

  @override
  State<SelectedItemTabs> createState() => _SelectedItemTabsState();
}

class _SelectedItemTabsState extends State<SelectedItemTabs>
    with SingleTickerProviderStateMixin {
  late List<Widget> _tabs;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const Tab(text: "Details"),
      Tab(
        child: Text(
          'Message',
          style: TextStyle(
            color: widget.pageCount == 1 ? gray : darkGray,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Logs',
          style: TextStyle(
            color: widget.pageCount == 1 ? gray : darkGray,
          ),
        ),
      ),
    ];
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5,
          left: 0,
          child: Text(
            widget.status?.capitalize ?? '',
            style: TextStyle(
              color: widget.status == "pending"
                  ? orange
                  : widget.status == "approved"
                      ? colorSuccess
                      : colorError,
            ),
          ),
        ),
        Positioned(
          top: -5,
          right: 0,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Center(
              child: Text(
                widget.title,
                style: blueTitleStyle,
              ),
            ),
            TabBar(
              labelPadding: EdgeInsets.zero,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              tabs: _tabs,
              controller: _tabController,
              onTap: (value) {
                if (widget.pageCount == 1) {
                  _tabController.index = 0;
                }
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  widget.detailPage,
                  const MessageTab(),
                  LogsTab(
                    isLoading: widget.isLogsLoading,
                    transactionLogs: widget.transactionLogs,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
