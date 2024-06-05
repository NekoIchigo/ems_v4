import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Widget child;

  const Home({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * .80,
          child: child,
        ),
      ],
    );
  }
}
