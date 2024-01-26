import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer(
      title: "Change Password",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Password",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Input(
                    isPassword: true,
                    textController: _currentPassword,
                    labelColor: primaryBlue,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "New Password",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Input(
                  isPassword: true,
                  textController: _newPassword,
                  labelColor: primaryBlue,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Re-enter Password",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Input(
                  isPassword: true,
                  textController: _confirmPassword,
                  labelColor: primaryBlue,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Center(
            child: RoundedCustomButton(
              onPressed: () {
                _createPasswordController.createNewPassword(_newPassword.text,
                    _confirmPassword.text, _currentPassword.text);
              },
              label: 'Update',
              radius: 5,
              size: Size(Get.width * .4, 30),
              bgColor: bgPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
