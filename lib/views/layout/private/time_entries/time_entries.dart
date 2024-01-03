import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries_container.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeEntries extends StatefulWidget {
  const TimeEntries({super.key});

  @override
  State<TimeEntries> createState() => _TimeEntriesState();
}

class _TimeEntriesState extends State<TimeEntries> {
  final TimeEntriesController _timeEntriesController =
      Get.find<TimeEntriesController>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        children: [
          Obx(
            () => Visibility(
              visible: _timeEntriesController.hasClose.isFalse,
              child: const SizedBox(height: 11),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Visibility(
                        visible: _timeEntriesController.hasClose.isTrue,
                        child: const SizedBox(width: 48),
                      ),
                    ),
                    const Text(
                      'Time Entries',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _timeEntriesController.hasClose.isTrue,
                  child: IconButton(
                    onPressed: () {
                      _timeEntriesController.hasClose.value = false;
                      _timeEntriesController.pageName.value = '/index';
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: Get.height * .66,
            child: const TimeEntriesContainer(),
          ),
        ],
      ),
    );
  }
}
