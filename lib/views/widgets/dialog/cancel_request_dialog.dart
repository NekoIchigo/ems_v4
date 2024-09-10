import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:lottie/lottie.dart';

class CancelRequestDialog extends StatelessWidget {
  final bool isLoading;
  final String title;
  final String subTitle;
  final Function() onPressed;

  const CancelRequestDialog({
    super.key,
    required this.isLoading,
    required this.title,
    this.subTitle = "Are you sure you want to cancel this request?",
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: Device.get().isTablet
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 100)
          : const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Container(
        padding: Device.get().isTablet
            ? const EdgeInsets.all(30)
            : const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 25,
                    color: textMuted,
                  ),
                )),
            Lottie.asset(
              "assets/lottie/question-icon-2.json",
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: textblack,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedCustomButton(
                  onPressed: () {
                    onPressed();
                  },
                  isLoading: isLoading,
                  label: "No, Keep Request",
                  bgColor: gray,
                  fontSize: 13,
                  size: Size(size.width * .38, 40),
                ),
                const SizedBox(width: 10),
                RoundedCustomButton(
                  onPressed: () {
                    onPressed();
                  },
                  isLoading: isLoading,
                  label: "Yes, Cancel Request",
                  bgColor: bgPrimaryBlue,
                  fontSize: 13,
                  size: Size(size.width * .4, 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
