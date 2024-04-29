import 'package:ems_v4/views/widgets/inputs/number_label.dart';
import 'package:flutter/material.dart';

class LogsTab extends StatelessWidget {
  const LogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NumberLabel(label: "Transaction created", number: 1),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text("Created by Reydan Belen"),
            ),
            const NumberLabel(label: "Transaction submitted", number: 2),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text("Status: Draft > Waiting for approval"),
            ),
            const NumberLabel(label: "Approvers", number: 3),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text("Level 1 waiting for approval"),
            ),
          ]
              .map((widget) => Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: widget,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
