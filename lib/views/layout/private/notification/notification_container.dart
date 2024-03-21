import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/notification/notification_index.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationContainer extends StatefulWidget {
  const NotificationContainer({super.key});

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer>
    with SingleTickerProviderStateMixin {
  final List<Widget> tabs = [
    const Tab(text: "New"),
    const Tab(text: "All"),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/svg/menu.svg'),
                )
              ],
            ),
            SizedBox(
              width: size.width * .4,
              child: TabBar(
                tabs: tabs,
                controller: _tabController,
              ),
            ),
            SizedBox(
              height: size.height * .7,
              child: TabBarView(
                  controller: _tabController,
                  children: const [NoResult(), NotificationIndex()]),
            ),
            Visibility(
              visible: false,
              child: SizedBox(
                height: size.height * .8,
                child: const ListShimmer(listLength: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
