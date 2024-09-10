import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class Overtime extends StatefulWidget {
  const Overtime({super.key});

  @override
  State<Overtime> createState() => _OvertimeState();
}

class _OvertimeState extends State<Overtime> {
  final OvertimeController _overtimeController = Get.find<OvertimeController>();
  final MessageController _messaging = Get.find<MessageController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

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
                  "Overtime",
                  style: titleStyle,
                ),
              ),
              const SizedBox(height: 20),
              MonthFilterDropdown(
                hasToday: false,
                onChanged: (value) {
                  DateTime startDate = DateTime.now();
                  DateTime endDate = DateTime.now();

                  if (value['day'] == 0) {
                    startDate = value['dates'][0];
                    endDate = value['dates'][1];
                  }
                  _overtimeController.getAllOvertime(
                    value['day'],
                    startDate,
                    endDate,
                  );
                },
              ),
              Obx(
                () => TransactionsTabs(
                  onTap: (TransactionItem? item) {
                    _messaging.subscribeInChannel(
                      channelName: "overtime-request-chat-${item!.id}",
                    );
                    _overtimeController.getLogs(item.id);
                    _messaging.fetchChatHistory(
                        item.id.toString(), "overtime-request-chat");
                    _overtimeController.transactionData = item.toMap().obs;
                    context.push('/overtime_form', extra: item.toMap());
                  },
                  approvedList: formatList(_overtimeController.approvedList),
                  cancelledList: formatList(_overtimeController.cancelledList),
                  pendingList: formatList(_overtimeController.pendingList),
                  rejectedList: formatList(_overtimeController.rejectedList),
                  isLoading: _overtimeController.isLoading.isTrue,
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
                _overtimeController.transactionData.value = {"id": "0"};
                context.push('/overtime_form');
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
    return data
        .map((request) => TransactionItem(
              id: request["id"],
              title: _dateTimeUtils
                  .fromLaravelDateFormat(request["attendance_date"]),
              dateCreated:
                  _dateTimeUtils.fromLaravelDateFormat(request["created_at"]),
              subtitle:
                  "Hours: ${request['total_hours']} | Start time ${request['start_time']}",
              status: request["status"],
              type: "",
              data: request,
            ))
        .toList();
  }
}
