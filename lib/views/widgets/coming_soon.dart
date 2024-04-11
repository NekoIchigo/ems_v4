import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(
            'assets/images/coming_soon.jpg',
            width: 280,
          ),
          Lottie.asset("assets/lottie/coming_soon.json", width: 250),
        ],
      ),
    );
  }
}
