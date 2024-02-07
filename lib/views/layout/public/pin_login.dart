import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PINLogin extends StatefulWidget {
  const PINLogin({super.key});

  @override
  State<PINLogin> createState() => _PINLoginState();
}

class _PINLoginState extends State<PINLogin> {
  late SharedPreferences _localStorage;

  final AuthService _authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  final TextEditingController _passwordController = TextEditingController();

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Hello, ${_authService.employee.value.firstName}!',
                    style: const TextStyle(
                      color: gray,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Enter your 6-digit PIN',
                    style: TextStyle(color: gray, fontSize: 12),
                  ),
                ),
                PinInput(
                  pinController: _passwordController,
                  label: '',
                  obscureText: true,
                  errorText: errorText,
                  validation: (p0) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Not your account? ",
                      style: TextStyle(
                        color: gray,
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        _localStorage = await SharedPreferences.getInstance();
                        _localStorage.setBool('auth_biometrics', false);
                        Get.toNamed('/login');
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      child: const Text(
                        'Switch now',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        "|",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: gray,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 1)),
                      onPressed: () {
                        Get.toNamed('/forgot_pin');
                      },
                      child: const Text(
                        'Forgot PIN?',
                        style: TextStyle(color: gray, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () async {
                      if (_authService.isLoading.isFalse) {
                        errorText = await _authService.pinAuth(
                          _passwordController.text,
                        );
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
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: const Text(
                      'Use password',
                      style: TextStyle(
                        color: gray,
                        fontSize: 12,
                      ),
                    ),
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
