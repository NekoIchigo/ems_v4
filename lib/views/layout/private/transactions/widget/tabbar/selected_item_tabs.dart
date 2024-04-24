import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/under_maintenance.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectedItemTabs extends StatefulWidget {
  final String? status;
  final String title;
  final Widget detailPage;
  const SelectedItemTabs({
    super.key,
    this.status,
    required this.title,
    required this.detailPage,
  });

  @override
  State<SelectedItemTabs> createState() => _SelectedItemTabsState();
}

class _SelectedItemTabsState extends State<SelectedItemTabs>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    const Tab(text: "Details"),
    const Tab(text: "Message"),
    const Tab(text: "Logs"),
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
                children: [
                  widget.detailPage,
                  const UnderMaintenance(
                    hasLogo: false,
                  ),
                  const UnderMaintenance(
                    hasLogo: false,
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
