import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _changeRestday.getAllChangeRestday();
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
                onChanged: (p0) {},
              ),
              TransactionsTabs(
                approvedList: formatList(_changeRestday.approvedList),
                cancelledList: formatList(_changeRestday.cancelledList),
                pendingList: formatList(_changeRestday.pendingList),
                rejectedList: formatList(_changeRestday.rejectedList),
                isLoading: _changeRestday.isLoading.value,
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
    return data
        .map((request) => TransactionItem(
              id: request["id"],
              title: _dateTimeUtils
                  .fromLaravelDateFormat(request["attendance_date"]),
              dateCreated:
                  _dateTimeUtils.fromLaravelDateFormat(request["created_at"]),
              subtitle: "New Restday: ${request['total_hours']}",
              status: request["status"],
              type: "",
            ))
        .toList();
  }
}
