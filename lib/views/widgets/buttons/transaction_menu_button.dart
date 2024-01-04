import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class TransactionMenuButton extends StatefulWidget {
  final Function() onPressed;
  final Widget child;
  const TransactionMenuButton(
      {super.key, required this.onPressed, required this.child});

  @override
  State<TransactionMenuButton> createState() => _TransactionMenuButtonState();
}

class _TransactionMenuButtonState extends State<TransactionMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(35),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          backgroundColor: bgSky,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
