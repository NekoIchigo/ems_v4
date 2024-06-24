import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogsTab extends StatelessWidget {
  final TransactionLogs? transactionLogs;
  final bool isLoading;
  const LogsTab({
    super.key,
    this.transactionLogs,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DateTimeUtils dateTimeUtils = DateTimeUtils();
    String creatorName = "", status = "", createdAt = "", updatedAt = "";
    List approvalHistory = [], level1 = [], level2 = [];
    if (transactionLogs != null) {
      var data = transactionLogs?.requestData?['data'];
      if (data != null) {
        approvalHistory =
            transactionLogs?.requestData?['approval_history'] ?? [];
        creatorName = data['employee_name']['employee_name'];

        status = data['status'];

        createdAt = dateTimeUtils.formatDate(
          dateTime: DateTime.parse(data['created_at']),
        );
        updatedAt = dateTimeUtils.formatDate(
          dateTime: DateTime.parse(data['updated_at']),
        );
        for (var approval in approvalHistory) {
          if (approval['level'] == 1) {
            level1.add(approval);
          } else if (approval['level'] == 2) {
            level2.add(approval);
          }
        }
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NumberLabel(label: "Transaction submitted", number: 1),
                  Text(createdAt)
                ],
              ),
              Visibility(
                visible: !isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text("Submitted by $creatorName"),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: CustomLoader(
                    height: 30,
                    borderRadius: 5,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NumberLabel(
                      label: "Transaction status updates", number: 2),
                  Text(updatedAt),
                ],
              ),
              Visibility(
                visible: !isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      const Text("Status: "),
                      Text(
                        status.capitalize ?? "",
                        style: TextStyle(
                          color: status == "pending"
                              ? orange
                              : status == "approved"
                                  ? colorSuccess
                                  : colorError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: CustomLoader(
                    height: 30,
                    borderRadius: 5,
                  ),
                ),
              ),
              const NumberLabel(label: "Approvers", number: 3),
              Visibility(
                visible: !isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsetsDirectional.all(5),
                      decoration: BoxDecoration(
                        color: bgPrimaryBlue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Level 1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .15,
                      child: ListView.builder(
                        itemCount: level1.length,
                        itemBuilder: (context, index) {
                          var approver = level1[index];
                          String approverStatus = approver['status'];
                          String approverDate = dateTimeUtils.formatDate(
                              dateTime: DateTime.parse(approver['updated_at']));
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .4,
                                    child: Text(
                                      approver['employee_name']
                                          ['employee_name'],
                                    ),
                                  ),
                                  Text(
                                    approverStatus.capitalize ?? "",
                                    style: TextStyle(
                                      color: approverStatus == "pending"
                                          ? orange
                                          : approverStatus == "approved"
                                              ? colorSuccess
                                              : colorError,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(approverDate),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: level2.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(5),
                        decoration: BoxDecoration(
                          color: bgPrimaryBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Level 2",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: level2.isNotEmpty,
                      child: SizedBox(
                        height: size.height * .15,
                        child: ListView.builder(
                          itemCount: level2.length,
                          itemBuilder: (context, index) {
                            var approver = level2[index];
                            String approverStatus = approver['status'];
                            String approverDate = dateTimeUtils.formatDate(
                                dateTime:
                                    DateTime.parse(approver['updated_at']));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .4,
                                      child: Text(
                                        approver['employee_name']
                                            ['employee_name'],
                                      ),
                                    ),
                                    Text(
                                      approverStatus.capitalize ?? "",
                                      style: TextStyle(
                                        color: approverStatus == "pending"
                                            ? orange
                                            : approverStatus == "approved"
                                                ? colorSuccess
                                                : colorError,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(approverDate),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: CustomLoader(
                    height: 30,
                    borderRadius: 5,
                  ),
                ),
              ),
            ]
                .map((widget) => Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: widget,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
