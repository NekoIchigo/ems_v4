import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
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

  String? passwordError;
  String? confrimPasswordError;

  @override
  void initState() {
    _createPasswordController.password.value = '';
    _createPasswordController.confirmPassword.value = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            errorText: passwordError,
            label: 'New password',
            isPassword: true,
            textController: _passwordController,
            icon: Icons.visibility,
            onChanged: (value) {
              _createPasswordController.password.value = value;
              setState(() {
                passwordError = null;
              });
            },
            validator: (p0) {},
          ),
          FloatingInput(
            label: 'Confirm password',
            isPassword: true,
            textController: _confirmPasswordController,
            icon: Icons.visibility,
            onChanged: (value) {
              _createPasswordController.confirmPassword.value = value;
            },
            validator: (p0) {},
          ),
          const SizedBox(height: 20),
          const PasswordValidation(),
          const SizedBox(height: 40),
          RoundedCustomButton(
            isLoading: _createPasswordController.isLoading.value,
            onPressed: () async {
              var error = await _createPasswordController.setNewPassword(
                _createPasswordController.password.value,
                _createPasswordController.confirmPassword.value,
              );
              passwordError = error['errors']['password'][0];
              // if (_passwordController.text != _confirmPasswordController.text) {
              //   confrimPasswordError = 'Password not match';
              // }
              setState(() {});
            },
            label: _createPasswordController.isLoading.isTrue
                ? "Submitting..."
                : "Submit",
            size: Size(size.width * .9, 40),
            bgColor: bgPrimaryBlue,
          ),
        ],
      ),
    );
  }
}
