import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/no_data.png',
          width: 400,
        ),
        const Text(
          'No Records',
          style: TextStyle(color: gray),
        ),
      ],
    );
  }
}
