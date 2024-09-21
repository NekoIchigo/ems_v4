import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/notification_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _notificationController =
      Get.find<NotificationController>();
  final DateTimeUtils _dateUtils = DateTimeUtils();

  @override
  void initState() {
    super.initState();
    _notificationController.index();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Notifications",
                style: blueTitleStyle,
              ),
            ),
          ),
          Obx(
            () => SizedBox(
              height: size.height * .75,
              child: _notificationController.isLoading.isTrue
                  ? const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: ListShimmer(
                        listLength: 10,
                        withLeading: true,
                      ),
                    )
                  : _notificationController.notificationList.isEmpty
                      ? const NoResult()
                      : ListView.builder(
                          itemCount:
                              _notificationController.notificationList.length,
                          itemBuilder: (context, index) {
                            final notificationItem =
                                _notificationController.notificationList[index];
                            final bool isChat =
                                notificationItem["notification_type"] == "chat";
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              color:
                                  index % 2 == 0 ? bgLightBlue : Colors.white,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isChat
                                              ? Icons.message
                                              : Icons.edit_note_rounded,
                                          color: bgSecondaryBlue,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: isChat
                                              ? Text(
                                                  "${notificationItem["user"]["name"]} left a message on your ${chatType(notificationItem['type'])}",
                                                  style: defaultStyle,
                                                )
                                              : Text(
                                                  notificationItem['message'],
                                                  style: defaultStyle,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Text(
                                      _dateUtils.formatDateTimeISO(
                                        notificationItem['updated_at'],
                                      ),
                                      style: const TextStyle(
                                          color: gray600, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          )
        ],
      ),
    );
  }

  String chatType(String chatType) {
    if (chatType == "dtr-request-chat") return "DTR Request";
    if (chatType == "schedule-request-chat") return "Change Schedule Request";
    if (chatType == "overtime-request-chat") return "Overtime Request";
    if (chatType == "leave-request-chat") return "Leave Request";
    if (chatType == "restday-request-chat") return "Change Restday Request";
    return "";
  }
}
