import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';

import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/floating_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController _authService = Get.find<AuthController>();
  final ApiCall apiCall = ApiCall();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _userNameError;
  String? _passwordError;
  String? _codeError;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                left: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/login_bg_image.jpg',
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * .15),
                        Center(
                          child: SizedBox(
                            height: size.height * 0.15,
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
                          'Code',
                          style: TextStyle(color: gray, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        FloatingInput(
                          label: '',
                          isPassword: false,
                          errorText: _codeError,
                          textController: _codeController,
                          iconColor: lightGray,
                          icon: Icons.business_rounded,
                          onChanged: (p0) {
                            setState(() {
                              _codeError = null;
                            });
                          },
                          validator: (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                _codeError = 'Please enter a value';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 10),
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
                                context.push('/forgot_password');
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
                            width: size.width * .55,
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
                                    _codeController.text,
                                  );
                                  if (error != null) {
                                    if (error.containsKey('errors')) {
                                      if (error['errors']
                                          .containsKey('email')) {
                                        _userNameError =
                                            error['errors']['email'][0];
                                      }
                                      if (error['errors']
                                          .containsKey('password')) {
                                        _passwordError =
                                            error['errors']['password'][0];
                                      }
                                      if (error['errors'].containsKey('code')) {
                                        _codeError = error['errors']['code'][0];
                                      }
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
                            size: Size(size.width, 20),
                            bgColor: bgPrimaryBlue,
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: _authService.hasUser.isTrue,
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  context.push('/pin_login');
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
            ],
          ),
        ),
      ),
    );
  }
}
