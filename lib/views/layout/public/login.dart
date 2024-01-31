import 'dart:developer';

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

  @override
  void initState() {
    super.initState();
    if (_authService.isSupported.isTrue) {
      log("Device supported");
    } else {
      log("This device is not supported");
    }
  }

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
                        'assets/images/EMS_logo_Blue.png',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Email',
                  style: TextStyle(color: gray, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => FloatingInput(
                    label: '',
                    isPassword: false,
                    textController: _emailController,
                    icon: _authService.isBioEnabled.isTrue
                        ? Icons.fingerprint
                        : Icons.mail,
                    iconColor: lightGray,
                    onIconPressed: () {
                      _authService.localAutheticate();
                    },
                    onChanged: (p0) {},
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
                  textController: _passwordController,
                  iconColor: lightGray,
                  icon: Icons.visibility,
                  onChanged: (p0) {},
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
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () async {
                      if (_authService.isLoading.isFalse) {
                        _authService.login(
                          _emailController.text,
                          _passwordController.text,
                        );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
