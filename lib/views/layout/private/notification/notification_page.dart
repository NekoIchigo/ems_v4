import 'package:auto_route/auto_route.dart';
import 'package:ems_v4/views/layout/private/notification/notification_container.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@RoutePage(name: "NotifPage")
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height * .78,
            child: const NotificationContainer(),
          ),
        ],
      ),
    );
  }
}
