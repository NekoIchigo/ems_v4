import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries_container.dart';
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
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 10,
            child: Visibility(
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
          Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                'Time Entries',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * .66,
                child: const TimeEntriesContainer(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
