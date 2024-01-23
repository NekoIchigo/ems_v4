import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Column(
        children: [
          Text("Forgot Password"),
          Container(
            color: bgPrimaryBlue,
            child: Icon(
              Icons.email_outlined,
              color: Colors.white,
            ),
          ),
          RoundedCustomButton(
            onPressed: () {},
            label: "Send One-Time Pin",
            size: Size(Get.width * .8, 40),
          )
        ],
      ),
    );
  }
}
