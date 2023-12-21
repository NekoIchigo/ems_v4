import 'package:ems_v3/View/private/time_entries/widgets/attendance_log.dart';
import 'package:ems_v3/View/private/time_entries/widgets/time_entries_index.dart';
import 'package:ems_v3/ViewModel/time_entries_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeEntriesContainer extends StatefulWidget {
  const TimeEntriesContainer({super.key});

  @override
  State<TimeEntriesContainer> createState() => _TimeEntriesContainerState();
}

class _TimeEntriesContainerState extends State<TimeEntriesContainer> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (_timeEntriesController.pageName.value) {
        case '/atttendance-log':
          return const AttendanceLog();
        // case '/home/result':
        //   return const HomeResultPage();
        // case '/home/health_declaration':
        //   return const HealthDeclaration();
        default:
          return const TimeEntriesIndex();
      }
    });
  }
}
