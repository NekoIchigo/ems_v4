// ignore_for_file: use_build_context_synchronously

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/notification_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/loader/list_shimmer.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController _notificationController =
      Get.find<NotificationController>();
  final DateTimeUtils _dateUtils = DateTimeUtils();
  final MessageController _messaging = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();
    _notificationController.index();
    _notificationController.showNotificationBadge.value = false;
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
      child: Stack(
        children: [
          Column(
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
                              itemCount: _notificationController
                                  .notificationList.length,
                              itemBuilder: (context, index) {
                                final notificationItem = _notificationController
                                    .notificationList[index];
                                final bool isChat =
                                    notificationItem["notification_type"] ==
                                        "chat";
                                return InkWell(
                                  onTap: () async {
                                    await onNotificationTap(
                                        notificationItem, isChat, context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    color: index % 2 == 0
                                        ? bgLightBlue
                                        : Colors.white,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
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
                                                        notificationItem[
                                                            'message'],
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
                                  ),
                                );
                              },
                            ),
                ),
              )
            ],
          ),
          Obx(
            () => Visibility(
              visible: _messaging.isLoading.isTrue ||
                  _notificationController.isTransactionLoading.isTrue,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: primaryBlue,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String chatType(String chatType) {
    if (chatType == "dtr-request-chat") return "DTR Request";
    if (chatType == "change-schedule-chat") return "Change Schedule Request";
    if (chatType == "overtime-request-chat") return "Overtime Request";
    if (chatType == "leave-request-chat") return "Leave Request";
    if (chatType == "restday-request-chat") return "Change Restday Request";
    return "";
  }

  Future onNotificationTap(
      notificationItem, isChat, BuildContext context) async {
    if (isChat) {
      await _messaging.fetchChatHistory(
        notificationItem["parent_id"].toString(),
        "overtime-request-chat",
      );
      _messaging.parentId.value = notificationItem["parent_id"].toString();
      _messaging.messagingType.value = "overtime-request-chat";
      context.push("/notification_chat");
    } else {
      if (notificationItem["particular"] == "overtime-request") {
        await _notificationController.showOvertime(
            notificationItem["parent_id"], context);
      } else if (notificationItem["particular"] == "change-schedule") {
        await _notificationController.showChangeSchedule(
            notificationItem["parent_id"], context);
      } else if (notificationItem["particular"] == "leave-request") {
        await _notificationController.showLeaveRequest(
            notificationItem["parent_id"], context);
      }
    }
  }
}
