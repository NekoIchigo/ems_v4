import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeSchedule extends StatefulWidget {
  const ChangeSchedule({super.key});

  @override
  State<ChangeSchedule> createState() => _ChangeScheduleState();
}

class _ChangeScheduleState extends State<ChangeSchedule> {
  final ChangeScheduleController _changeSchedule =
      Get.find<ChangeScheduleController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final MessageController _messaging = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 0,
            child: IconButton(
              onPressed: () {
                context.go("/transaction");
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  "Change Schedule",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MonthFilterDropdown(
                onChanged: (p0) {},
              ),
              Obx(
                () => TransactionsTabs(
                  onTap: (TransactionItem? item) {
                    _messaging.subscribeInChannel(
                      channelName: "change-schedule-request-chat-${item!.id}",
                    );
                    _messaging.fetchChatHistory(
                        item.id.toString(), "change-schedule-request-chat");
                    context.push('/change_schedule_form', extra: item.toMap());
                  },
                  approvedList: formatList(_changeSchedule.approvedList),
                  cancelledList: formatList(_changeSchedule.cancelledList),
                  pendingList: formatList(_changeSchedule.pendingList),
                  rejectedList: formatList(_changeSchedule.rejectedList),
                  isLoading: _changeSchedule.isLoading.isTrue,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: size.height * .10,
            right: 10,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: bgPrimaryBlue,
              onPressed: () {
                context.push('/change_schedule_form');
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TransactionItem> formatList(List data) {
    return data.map((request) {
      String title =
          "${_dateTimeUtils.fromLaravelDateFormat(request["start_date"])} to ${_dateTimeUtils.fromLaravelDateFormat(request["end_date"])}";
      return TransactionItem(
        id: request["id"],
        title: title,
        dateCreated: _dateTimeUtils.fromLaravelDateFormat(
          request["created_at"],
        ),
        subtitle: "New Schedule: Schedule Name",
        status: request["status"],
        type: "",
        data: request,
      );
    }).toList();
  }
}
