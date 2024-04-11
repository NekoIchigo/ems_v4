import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPInputPage extends StatefulWidget {
  const OTPInputPage({super.key});

  @override
  State<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends State<OTPInputPage> {
  final TextEditingController _otpController = TextEditingController();
  final CreatePasswordController _passwordController =
      Get.find<CreatePasswordController>();

  String? otpError;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verification via OTP",
            style: TextStyle(color: primaryBlue, fontSize: 16),
          ),
          const Text(
            "Enter the 6-digit code.",
            style: TextStyle(color: gray),
          ),
          const SizedBox(height: 10),
          PinInput(
            pinController: _otpController,
            label: '',
            validation: (p0) {},
            errorText: otpError,
          ),
          const SizedBox(height: 20),
          Obx(
            () => RoundedCustomButton(
              onPressed: () async {
                var error =
                    await _passwordController.verifyOTP(_otpController.text);
                // _passwordController.animateToThirdPage();
                otpError = error['message'];
                setState(() {});
              },
              isLoading: _passwordController.isLoading.value,
              label:
                  _passwordController.isLoading.isTrue ? "Verifying" : "Verify",
              size: Size(size.width * .9, 30),
              bgColor: bgPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
