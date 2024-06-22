import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ChangeRestday extends StatefulWidget {
  const ChangeRestday({super.key});

  @override
  State<ChangeRestday> createState() => _ChangeRestdayState();
}

class _ChangeRestdayState extends State<ChangeRestday> {
  final ChangeRestdayController _changeRestday =
      Get.find<ChangeRestdayController>();
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
                  "Change Restday",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MonthFilterDropdown(
                onChanged: (value) {
                  DateTime startDate = DateTime.now();
                  DateTime endDate = DateTime.now();

                  if (value['day'] == 0) {
                    startDate = value['dates'][0];
                    endDate = value['dates'][1];
                  }
                  _changeRestday.getAllChangeRestday(
                    value['day'],
                    startDate,
                    endDate,
                  );
                },
              ),
              Obx(
                () => TransactionsTabs(
                  onTap: (TransactionItem? item) {
                    _changeRestday.getLogs(item!.id);
                    _messaging.subscribeInChannel(
                      channelName: "restday-request-chat-${item.id}",
                    );
                    _messaging.fetchChatHistory(
                        item.id.toString(), "restday-request-chat");
                    context.push('/change_restday_form', extra: item.toMap());
                  },
                  approvedList: formatList(_changeRestday.approvedList),
                  cancelledList: formatList(_changeRestday.cancelledList),
                  pendingList: formatList(_changeRestday.pendingList),
                  rejectedList: formatList(_changeRestday.rejectedList),
                  isLoading: _changeRestday.isLoading.isTrue,
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
                context.push('/change_restday_form');
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
      return TransactionItem(
        id: request["id"],
        title:
            "${_dateTimeUtils.fromLaravelDateFormat(request["start_date"])} - ${_dateTimeUtils.fromLaravelDateFormat(request["end_date"])}",
        dateCreated:
            _dateTimeUtils.fromLaravelDateFormat(request["created_at"]),
        subtitle: "New Restday: ${request['new_rest_days'].join(", ")}",
        status: request["status"],
        type: "",
        data: request,
      );
    }).toList();
  }
}
