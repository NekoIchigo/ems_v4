import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class ProfileListButton extends StatefulWidget {
  final Function() onPressed;
  final String label;
  final Widget? leading;
  const ProfileListButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.leading,
  });

  @override
  State<ProfileListButton> createState() => _ProfileListButtonState();
}

class _ProfileListButtonState extends State<ProfileListButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * .7,
            child: Text(
              widget.label,
              style: const TextStyle(
                color: gray,
                fontSize: 14,
              ),
            ),
          ),
          widget.leading ??
              const Icon(
                Icons.navigate_next_outlined,
                color: gray,
              )
        ],
      ),
    );
  }
}
