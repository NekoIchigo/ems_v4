import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/floating_input.dart';
import 'package:ems_v4/views/widgets/validation/password_valdiation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    _createPasswordController.password.value = '';
    _createPasswordController.confirmPassword.value = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          FloatingInput(
            label: 'New password',
            isPassword: true,
            errorText: passwordError,
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
            onPressed: () async {
              var error = await _createPasswordController.createNewPassword(
                _passwordController.text,
                _confirmPasswordController.text,
                null,
              );

              if (error.containsKey('errors')) {
                passwordError = error['errors']['password'][0];
              }
              setState(() {});
            },
            label: "Next",
            size: Size(Get.width * .9, 40),
            bgColor: bgPrimaryBlue,
          ),
        ],
      ),
    );
  }
}
