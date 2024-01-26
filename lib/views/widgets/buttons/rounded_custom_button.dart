import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RoundedCustomButton extends StatefulWidget {
  final void Function() onPressed;
  final String label;
  final Color? bgColor;
  final Color? borderColor;
  final Color? textColor;
  final double? radius;
  final Size size;
  final bool? isLoading;
  const RoundedCustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.textColor,
    this.radius,
    required this.size,
    this.borderColor,
    this.isLoading,
  });

  @override
  State<RoundedCustomButton> createState() => _RoundedCustomButtonState();
}

class _RoundedCustomButtonState extends State<RoundedCustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: widget.borderColor ?? widget.bgColor ?? primaryBlue,
          ),
          fixedSize: widget.size,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.radius ?? 50))),
          backgroundColor: widget.bgColor ?? primaryBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.isLoading ?? false,
              child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
