import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';

import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/floating_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _userNameError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('assets/images/bgimage.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * .15),
                  Center(
                    child: SizedBox(
                      height: Get.height * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          'assets/images/GEMS4blue.png',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Username',
                    style: TextStyle(color: gray, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => FloatingInput(
                      label: '',
                      isPassword: false,
                      errorText: _userNameError,
                      textController: _emailController,
                      icon: _authService.isBioEnabled.isTrue
                          ? Icons.fingerprint
                          : Icons.mail,
                      iconColor: lightGray,
                      onIconPressed: () {
                        _authService.localAuthenticate();
                      },
                      onChanged: (p0) {
                        setState(() {
                          _userNameError = null;
                        });
                      },
                      validator: (value) {
                        setState(() {
                          if (value == null || value.isEmpty) {
                            _userNameError = 'Please enter a value';
                          }
                        });
                      },
                    ),
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(color: gray, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  FloatingInput(
                    label: '',
                    isPassword: true,
                    errorText: _passwordError,
                    textController: _passwordController,
                    iconColor: lightGray,
                    icon: Icons.visibility,
                    onChanged: (p0) {
                      setState(() {
                        _passwordError = null;
                      });
                    },
                    validator: (value) {
                      setState(() {
                        if (value == null || value.isEmpty) {
                          _passwordError = 'Please enter a value';
                        }
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/forgot_password');
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: gray, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: Get.width * .55,
                      child: const Text(
                        "By logging in, you agree to our Privacy Policy and Terms of Use.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: gray, fontSize: 12),
                      ),
                    ),
                  ),
                  Obx(
                    () => RoundedCustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {});
                          if (_authService.isLoading.isFalse) {
                            var error = await _authService.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (error != null) {
                              if (error.containsKey('errors')) {
                                // _userNameError = error['errors']['email'][0];
                                // _passwordError = error['errors']['password'][0];
                              } else if (error.containsKey('success') &&
                                  error.containsKey('message')) {
                                _userNameError = error['message'];
                                _passwordError = error['message'];
                              }
                            }
                          }
                          setState(() {});
                        }
                      },
                      isLoading: _authService.isLoading.value,
                      label: _authService.isLoading.isFalse
                          ? 'Log In'
                          : 'Logging In...',
                      radius: 50,
                      size: Size(Get.width, 20),
                      bgColor: bgPrimaryBlue,
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: _authService.hasUser.isTrue,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/pin_login');
                          },
                          child: const Text(
                            'Use PIN',
                            style: TextStyle(
                              color: gray,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
