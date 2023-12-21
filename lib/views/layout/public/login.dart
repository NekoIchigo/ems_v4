import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';

import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/underline_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Image.asset(
                      'assets/images/EMS_logo_Blue.png',
                      width: Get.width,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.82,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: Get.width,
                      height: Get.height * 0.81,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: Get.height * .45,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: bgPrimaryBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 25),
                                  const Text(
                                    'Welcome',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Login to continue',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          UnderlineInput(
                                            label: 'Email',
                                            isPassword: false,
                                            textController: _emailController,
                                            icon: Icons.mail,
                                          ),
                                          UnderlineInput(
                                            label: 'Password',
                                            isPassword: true,
                                            textController: _passwordController,
                                            icon: Icons.visibility,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Forgot Password?',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Obx(
                                            () => RoundedCustomButton(
                                              onPressed: () async {
                                                if (_authService
                                                    .isLoading.isFalse) {
                                                  _authService.login(
                                                    _emailController.text,
                                                    _passwordController.text,
                                                    context,
                                                  );
                                                }
                                              },
                                              label:
                                                  _authService.isLoading.isFalse
                                                      ? 'Log In'
                                                      : 'Logging In...',
                                              radius: 50,
                                              size: Size(Get.width, 50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            child: Image.asset(
                              'assets/images/EMS1.png',
                              width: Get.width * .75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: bgPrimaryBlue,
                      height: 1.5,
                      fontSize: 12,
                    ),
                    TextSpan(children: [
                      const TextSpan(
                        text: 'By logging in, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchInBrowser(
                                'https://happyhousekeepers.com.ph/privacy-policy');
                          },
                      ),
                      const TextSpan(
                        text: 'and ',
                      ),
                      TextSpan(
                        text: 'Terms of User',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchInBrowser(
                                'https://happyhousekeepers.com.ph/privacy-policy');
                          },
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
