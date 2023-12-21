import 'package:ems_v3/View/private/time_entries/time_entries_container.dart';
import 'package:ems_v3/ViewModel/time_entries_controller.dart';
import 'package:ems_v3/Global/constants.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * .12,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      bgPrimaryBlue.withOpacity(0.9),
                      bgSecondaryBlue.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Image.asset(
                  'assets/images/EMS_logo.png',
                  height: 85,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height * .9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Visibility(
                          visible: _timeEntriesController.hasClose.isTrue,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 10.0, 10.0, 0),
                              child: IconButton(
                                onPressed: () {
                                  _timeEntriesController.hasClose.value = false;
                                  _timeEntriesController.pageName.value =
                                      '/index';
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: _timeEntriesController.hasClose.isFalse,
                          child: const SizedBox(height: 58),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Center(
                          child: Text(
                            'Time Entries',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * .66,
                        child: const TimeEntriesContainer(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
