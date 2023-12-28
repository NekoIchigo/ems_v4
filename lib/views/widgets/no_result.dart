import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_data.png',
            width: 400,
          ),
          const Text('No Records'),
        ],
      ),
    );
  }
}
