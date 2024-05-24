import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/logs_tab.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/message_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectedItemTabs extends StatefulWidget {
  final String? status;
  final String title;
  final Widget detailPage;
  final int pageCount;
  const SelectedItemTabs({
    super.key,
    this.status,
    required this.title,
    required this.detailPage,
    required this.pageCount,
  });

  @override
  State<SelectedItemTabs> createState() => _SelectedItemTabsState();
}

class _SelectedItemTabsState extends State<SelectedItemTabs>
    with SingleTickerProviderStateMixin {
  final List<String> _tabsTitle = [
    "Details",
    "Message",
    "Logs",
  ];
  List<Tab> _tabs = [];
  List<Widget> _tabContent = [];

  late TabController _tabController;

  @override
  void initState() {
    _tabs = getTabs(widget.pageCount);
    _tabController = getTabController();
    _tabContent = getTabContent(widget.pageCount);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(getTab(_tabsTitle[i]));
    }
    return _tabs;
  }

  Tab getTab(String title) {
    return Tab(
      text: title,
    );
  }

  TabController getTabController() {
    return TabController(length: widget.pageCount, vsync: this);
  }

  List<Widget> getTabContent(int count) {
    List<Widget> contents = [
      widget.detailPage,
      MessageTab(),
      const LogsTab(),
    ];
    _tabContent.clear();
    for (int i = 0; i < count; i++) {
      _tabContent.add(contents[i]);
    }

    return _tabContent;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 5,
          left: 0,
          child: Text(
            widget.status ?? '',
            style: TextStyle(
              color: widget.status == "Pending"
                  ? orange
                  : widget.status == "Approved"
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
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            TabBar(
              labelPadding: EdgeInsets.zero,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
              tabs: _tabs,
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: _tabContent,
              ),
            ),
          ],
        )
      ],
    );
  }
}
