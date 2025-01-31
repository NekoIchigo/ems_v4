import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/add_shift_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/views/widgets/buttons/transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TransactionMenu extends StatefulWidget {
  const TransactionMenu({super.key});

  @override
  State<TransactionMenu> createState() => _TransactionMenuState();
}

class _TransactionMenuState extends State<TransactionMenu> {
  final DTRCorrectionController _dtrCorrection =
      Get.find<DTRCorrectionController>();
  final MainNavigationController _mainNavigationController =
      Get.find<MainNavigationController>();
  final LeaveController _leave = Get.find<LeaveController>();
  final OvertimeController _overtimeController = Get.find<OvertimeController>();
  final ChangeScheduleController _changeSchedule =
      Get.find<ChangeScheduleController>();
  final ChangeRestdayController _changeRestday =
      Get.find<ChangeRestdayController>();
  final AddShiftController _addShiftController = Get.find<AddShiftController>();

  final List transactionItems = [
    {
      "title": "Time Records",
      "key": "time_records",
      "icon": const Icon(
        Icons.calendar_month,
        size: 50,
        color: primaryBlue,
      ),
      "path": "/time_records",
    },
    {
      "title": "DTR Correction",
      "key": "dtr_correction",
      "icon": const Icon(
        Icons.edit_calendar_rounded,
        size: 50,
        color: primaryBlue,
      ),
      "path": "/dtr_correction",
    },
    {
      "title": "Leave",
      "key": "leave",
      "icon": SvgPicture.asset(
        "assets/svg/leave.svg",
        height: 45,
        color: primaryBlue,
      ),
      "path": "/leave",
    },
    {
      "title": "Overtime",
      "key": "overtime",
      "icon": const Icon(
        Icons.more_time,
        size: 50,
        color: primaryBlue,
      ),
      "path": "/overtime",
    },
    {
      "title": "Change Schedule",
      "key": "change_schedule",
      "icon": SvgPicture.asset(
        "assets/svg/change_schedule.svg",
        height: 50,
        color: primaryBlue,
      ),
      "path": "/change_schedule",
    },
    {
      "title": "Change Restday",
      "key": "change_restday",
      "icon": SvgPicture.asset(
        "assets/svg/change_restday.svg",
        height: 50,
        color: primaryBlue,
      ),
      "path": "/change_restday",
    },
    {
      "title": "Add New Schedule",
      "key": "add_shift",
      "icon": SvgPicture.asset(
        "assets/svg/file_plus.svg",
        height: 50,
        color: primaryBlue,
      ),
      "path": "/add_shift",
    },
  ];

  @override
  void initState() {
    super.initState();
    removeFalseValuesFromList();
  }

  void removeFalseValuesFromList() {
    transactionItems.removeWhere((item) {
      String key = item['key'];

      return !_mainNavigationController.transactionAccess[key];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 25),
          const Text(
            "Transactions",
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: size.height * .7,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                mainAxisExtent: 130,
              ),
              itemCount: transactionItems.length,
              itemBuilder: (context, index) {
                String path = transactionItems[index]["path"];
                return Visibility(
                  visible: _mainNavigationController
                      .transactionAccess[transactionItems[index]['key']],
                  child: TransactionMenuButton(
                    onPressed: () {
                      if (path == "/dtr_correction") {
                        _dtrCorrection.getAllDTR(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      } else if (path == "/leave") {
                        _leave.getAllLeave(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      } else if (path == "/overtime") {
                        _overtimeController.getAllOvertime(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      } else if (path == "/change_schedule") {
                        _changeSchedule.getAllChangeSchedule(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      } else if (path == "/change_restday") {
                        _changeRestday.getAllChangeRestday(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      } else if (path == "/add_shift") {
                        _addShiftController.getAllAddShift(
                          30,
                          DateTime.now(),
                          DateTime.now(),
                        );
                      }
                      context.push(path);
                    },
                    title: transactionItems[index]["title"],
                    child: Center(
                      child: transactionItems[index]["icon"],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
