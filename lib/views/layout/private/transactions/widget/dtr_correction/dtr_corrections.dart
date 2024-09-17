import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DTRCorrection extends StatefulWidget {
  const DTRCorrection({super.key});

  @override
  State<DTRCorrection> createState() => _DTRCorrectionState();
}

class _DTRCorrectionState extends State<DTRCorrection> {
  final DTRCorrectionController _correctionController =
      Get.find<DTRCorrectionController>();
  final TransactionController _transactionController =
      Get.find<TransactionController>();
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
                  "DTR Correction",
                  style: blueTitleStyle,
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
                  _correctionController.getAllDTR(
                    value['day'],
                    startDate,
                    endDate,
                  );
                },
              ),
              Obx(
                () => TransactionsTabs(
                  onTap: (TransactionItem? item) {
                    _correctionController.getLogs(item!.id);
                    // _messaging.subscribeInChannel(
                    //   channelName: "dtr-request-chat-${item.id}",
                    // );
                    _messaging.fetchChatHistory(
                      item.id.toString(),
                      "dtr-request-chat",
                    );
                    _messaging.parentId.value = item.id.toString();
                    _messaging.messagingType.value = "dtr-request-chat";
                    _correctionController.transactionData = item.toMap().obs;
                    context.push("/dtr_correction_form", extra: item.toMap());
                  },
                  approvedList: formatList(_correctionController.approvedList),
                  cancelledList:
                      formatList(_correctionController.cancelledList),
                  pendingList: formatList(_correctionController.pendingList),
                  rejectedList: formatList(_correctionController.rejectedList),
                  isLoading: _correctionController.isLoading.isTrue,
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
                _correctionController.transactionData = {"id": "0"}.obs;
                _transactionController.clockOutAt.value = "00:00";
                _transactionController.clockInAt.value = "00:00";
                context.push("/dtr_correction_form");
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
        .map(
          (request) => TransactionItem(
            id: request["id"],
            title: _dateTimeUtils
                .fromLaravelDateFormat(request["attendance_date"]),
            dateCreated:
                _dateTimeUtils.fromLaravelDateFormat(request["created_at"]),
            subtitle:
                "Clock in: ${_dateTimeUtils.formatTime(dateTime: DateTime.parse(request['clock_in_at']))} | Clock out: ${_dateTimeUtils.formatTime(dateTime: DateTime.parse(request['clock_out_at']))}",
            status: request["status"],
            type: "",
            data: request,
          ),
        )
        .toList();
  }
}
