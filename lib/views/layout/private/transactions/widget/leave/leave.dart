import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/transactions_tabs.dart';
import 'package:ems_v4/views/widgets/dropdown/month_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final LeaveController _leave = Get.find<LeaveController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();

  @override
  void initState() {
    super.initState();
    _leave.getAllLeave();
  }

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
                  "Leave",
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
                    print(item.toString());
                  },
                  approvedList: formatList(_leave.approvedList),
                  cancelledList: formatList(_leave.cancelledList),
                  pendingList: formatList(_leave.pendingList),
                  rejectedList: formatList(_leave.rejectedList),
                  isLoading: _leave.isLoading.isTrue,
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
                _leave.getAvailableLeave();
                context.push('/leave_form');
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
        dateCreated:
            _dateTimeUtils.fromLaravelDateFormat(request["created_at"]),
        subtitle: "Leave count: ${request['leave_count']}",
        status: request["status"],
        type: "",
      );
    }).toList();
  }
}
