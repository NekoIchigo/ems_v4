import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/underline_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailOTP extends StatefulWidget {
  const EmailOTP({super.key});

  @override
  State<EmailOTP> createState() => _EmailOTPState();
}

class _EmailOTPState extends State<EmailOTP> {
  final TextEditingController _emailController = TextEditingController();
  final CreatePasswordController _passwordController =
      Get.find<CreatePasswordController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Email",
            style: TextStyle(color: primaryBlue, fontSize: 16),
          ),
          const Text(
            "Provide your account email address.",
            style: TextStyle(color: gray),
          ),
          const SizedBox(height: 10),
          UnderlineInput(
            label: 'Email',
            isPassword: false,
            icon: Icons.email_outlined,
            textController: _emailController,
          ),
          const SizedBox(height: 20),
          RoundedCustomButton(
            onPressed: () async {
              await Get.dialog(
                barrierDismissible: false,
                GetDialog(
                  type: 'success',
                  title: 'One-Time Pin Sent',
                  hasMessage: true,
                  message: "An OTP has been sent to verify your email address",
                  buttonNumber: 1,
                  hasCustomWidget: true,
                  withCloseButton: false,
                  okPress: () {
                    Get.back();
                  },
                  okText: "Close",
                  okButtonBGColor: gray,
                ),
              );
              _passwordController.animateToSecondPage();
            },
            label: "Send One-Time Pin",
            size: Size(Get.width * .9, 40),
            bgColor: bgPrimaryBlue,
          )
        ],
      ),
    );
  }
}
