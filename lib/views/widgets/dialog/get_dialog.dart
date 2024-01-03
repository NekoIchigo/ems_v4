import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GetDialog extends StatelessWidget {
  final String type;
  final String title;
  final bool hasMessage;
  final String? message;
  final String? lottieLink;
  final int buttonNumber;
  final String? okText;
  final bool hasCustomWidget;
  final Widget? customWidget;
  final bool withCloseButton;
  final Color? okButtonBGColor;
  final void Function()? okPress;

  final void Function()? cancelPress;
  final String? cancelText;

  const GetDialog({
    super.key,
    required this.type,
    required this.title,
    this.message,
    required this.hasMessage,
    this.lottieLink,
    required this.buttonNumber,
    this.okText,
    required this.hasCustomWidget,
    this.customWidget,
    required this.withCloseButton,
    this.okButtonBGColor,
    this.okPress,
    this.cancelPress,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: Device.get().isTablet
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 100)
          : const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Container(
        padding: buttonNumber != 0
            ? Device.get().isTablet
                ? const EdgeInsets.all(30)
                : const EdgeInsets.all(15)
            : Device.get().isTablet
                ? const EdgeInsets.fromLTRB(25, 30, 25, 55)
                : const EdgeInsets.fromLTRB(15, 15, 15, 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: withCloseButton,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 25,
                            color: textMuted,
                          ),
                        )),
                  ),
                  Lottie.asset(
                    type == "question"
                        ? 'assets/lottie/question.json'
                        : type == "error"
                            ? 'assets/lottie/error-icon-2.json'
                            : type == "success"
                                ? 'assets/lottie/success-icon-4.json'
                                : "assets/lottie/info.json",
                    repeat: false,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: type == "success"
                            ? colorSuccess
                            : type == "error"
                                ? colorError
                                : type == "question"
                                    ? colorQuestion
                                    : colorQuestion,
                      ),
                    ),
                  ),
                  Visibility(
                      visible: hasCustomWidget,
                      child: customWidget ?? Container()),
                  Visibility(
                    visible: hasMessage,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        message ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: textblack,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: buttonNumber != 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: buttonNumber == 1
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: buttonNumber == 2,
                            child: SizedBox(
                              width: Device.get().isTablet
                                  ? Get.width * 0.28
                                  : Get.width * 0.37,
                              child: ElevatedButton(
                                onPressed: cancelPress,
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                    backgroundColor: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 10.0),
                                  child: Text(
                                    cancelText ?? "Cancel",
                                    style: GoogleFonts.plusJakartaSans(
                                      textStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: textblack,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Device.get().isTablet
                                ? Get.width * 0.28
                                : Get.width * 0.37,
                            child: ElevatedButton(
                              onPressed: okPress,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                  backgroundColor:
                                      okButtonBGColor ?? primaryBlue),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10.0),
                                child: Text(
                                  okText ?? "OK",
                                  style: GoogleFonts.plusJakartaSans(
                                    textStyle: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
