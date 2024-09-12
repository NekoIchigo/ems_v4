import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class TransactionMenuButton extends StatefulWidget {
  final Function() onPressed;
  final String title;
  final Widget child;
  const TransactionMenuButton(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.title});

  @override
  State<TransactionMenuButton> createState() => _TransactionMenuButtonState();
}

class _TransactionMenuButtonState extends State<TransactionMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          width: 90,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: widget.onPressed,
            icon: widget.child,
            splashColor: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: bgSky,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.title,
          style: defaultStyle,
        ),
      ],
    );
  }
}
