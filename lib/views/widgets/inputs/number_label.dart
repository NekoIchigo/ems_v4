import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class NumberLabel extends StatelessWidget {
  final String label;
  final int number;

  const NumberLabel({super.key, required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: primaryBlue,
          radius: 10,
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
