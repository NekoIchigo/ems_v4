import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:ems_v4/views/widgets/validation/password_valdiation.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    _createPasswordController.password.value = '';
    _createPasswordController.confirmPassword.value = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer(
      title: "Change Password",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Form(
              key: _formKey,
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
                      onChanged: (value) {
                        setState(() {
                          _currentPasswordError = null;
                        });
                      },
                      // errorText: _currentPasswordError,
                      validator: (value) {
                        setState(() {
                          if (value == null || value.isEmpty) {
                            _currentPasswordError = 'Please enter a value';
                          } else if (_currentPasswordError != null) {
                            _currentPasswordError = _currentPasswordError;
                          }
                        });
                        return _currentPasswordError;
                      },
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
                    // errorText: _newPasswordError,
                    onChanged: (value) {
                      setState(() {
                        _newPasswordError = null;
                        _createPasswordController.password.value = value;
                      });
                    },
                    validator: (value) {
                      setState(() {
                        if (value == null || value.isEmpty) {
                          _newPasswordError = 'Please enter a value';
                        } else if (_newPasswordError != null) {
                          _newPasswordError = _newPasswordError;
                        }
                      });
                      return _newPasswordError;
                    },
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
                    // errorText: _confirmPasswordError,
                    onChanged: (value) {
                      setState(() {
                        _confirmPasswordError = null;
                      });
                      _createPasswordController.confirmPassword.value = value;
                    },
                    validator: (value) {
                      setState(() {
                        if (value == null || value.isEmpty) {
                          _confirmPasswordError = 'Please enter a value';
                        } else if (_newPassword.text != _confirmPassword.text) {
                          _confirmPasswordError = 'Password not match';
                        }
                      });
                      return _confirmPasswordError;
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const PasswordValidation(),
          const SizedBox(height: 30),
          Center(
            child: RoundedCustomButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var errors =
                      await _createPasswordController.createNewPassword(
                          _newPassword.text,
                          _confirmPassword.text,
                          _currentPassword.text);
                  if (errors['message'].contains("current")) {
                    _currentPasswordError = errors['message'];
                  } else if (errors.containsKey('errors')) {
                    _newPasswordError = errors['errors']['password'][0];
                  }
                }
                setState(() {});
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
