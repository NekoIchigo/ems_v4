import 'package:ems_v4/views/widgets/coming_soon.dart';
import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key, required this.child});
  final Widget child;
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
      child:
          //  child,
          const Center(child: ComingSoon()),
    );
  }
}
