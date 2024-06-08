import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 10,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  "May 1 - May 15, 2024",
                  style: TextStyle(fontSize: 18, color: bgPrimaryBlue),
                ),
              ),
              SizedBox(
                height: size.height * .75,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: gray),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Wednesday, May ${index + 1}, 2024"),
                          const Divider(),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Schedule',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "08:30 am to 05:30 pm",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Clock In',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "08:30 am | 05/01/2024",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Clock Out',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "05:30 pm | 05/01/2024",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Day Type',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "Regular",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Worked Hours',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'OT',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Late',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Undertime',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Night diff.',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .35,
                                child: const Text(
                                  'Night diff. OT',
                                  style: TextStyle(color: gray),
                                ),
                              ),
                              const Text(
                                "00:00",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ],
                          ),
                        ]
                            .map((child) => Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: child,
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
