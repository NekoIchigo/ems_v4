import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final Widget child;
  const Profile({super.key, required this.child});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * .78,
            child: child,
          ),
        ],
      ),
    );
  }
}
