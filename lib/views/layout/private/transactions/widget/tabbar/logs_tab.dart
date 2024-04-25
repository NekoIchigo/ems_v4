import 'package:ems_v4/views/widgets/inputs/reason_input.dart';
import 'package:flutter/material.dart';

class LogsTab extends StatelessWidget {
  const LogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(),
          const Text("adsa"),
          const ReasonInput(readOnly: false),
        ],
      ),
    );
  }
}
