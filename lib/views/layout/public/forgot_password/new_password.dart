import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/floating_input.dart';
import 'package:ems_v4/views/widgets/validation/password_valdiation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Set New Password",
              style: TextStyle(
                color: primaryBlue,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FloatingInput(
            label: 'New password',
            isPassword: true,
            textController: _passwordController,
            icon: Icons.visibility,
          ),
          FloatingInput(
            label: 'Confirm password',
            isPassword: true,
            textController: _confirmPasswordController,
            icon: Icons.visibility,
          ),
          const SizedBox(height: 20),
          const PasswordValidation(),
          const SizedBox(height: 40),
          RoundedCustomButton(
            onPressed: () {
              Get.dialog(
                barrierDismissible: false,
                GetDialog(
                  type: 'success',
                  title: 'Password Updated',
                  hasMessage: true,
                  message: "You can now log in using your new password.",
                  buttonNumber: 1,
                  hasCustomWidget: true,
                  withCloseButton: false,
                  okPress: () {
                    Get.offNamed("/login");
                  },
                  okText: "Log in",
                  okButtonBGColor: bgPrimaryBlue,
                ),
              );
            },
            label: "Submit",
            size: Size(Get.width * .9, 40),
            bgColor: bgPrimaryBlue,
          ),
        ],
      ),
    );
  }
}
