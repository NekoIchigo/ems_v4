import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsTabbar extends StatefulWidget {
  const TransactionsTabbar({super.key});

  @override
  State<TransactionsTabbar> createState() => _TransactionsTabbarState();
}

class _TransactionsTabbarState extends State<TransactionsTabbar>
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelPadding: EdgeInsets.zero,
          indicatorPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          tabs: _tabs,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(color: bgPrimaryBlue, fontSize: 13),
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
          height: Get.height * .6,
          child: TabBarView(
            controller: _tabController,
            children: [],
          ),
        ),
      ],
    );
  }
}
