import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class TimeEntries extends StatefulWidget {
  final Widget child;
  const TimeEntries({super.key, required this.child});

  @override
  State<TimeEntries> createState() => _TimeEntriesState();
}

class _TimeEntriesState extends State<TimeEntries> {
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
            child: GetBuilder<TimeEntriesController>(builder: (controller) {
              return Visibility(
                visible: controller.hasClose.isTrue,
                child: IconButton(
                  onPressed: () {
                    controller.hasClose.value = false;
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              );
            }),
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
                child: widget.child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
