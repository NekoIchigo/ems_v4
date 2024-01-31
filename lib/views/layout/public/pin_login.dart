import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PINLogin extends StatefulWidget {
  const PINLogin({super.key});

  @override
  State<PINLogin> createState() => _PINLoginState();
}

class _PINLoginState extends State<PINLogin> {
  final AuthService _authService = Get.find<AuthService>();
  final ApiCall apiCall = ApiCall();
  final TextEditingController _passwordController = TextEditingController();
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
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    'Enter your 6-digit PIN',
                    style: TextStyle(color: gray, fontSize: 12),
                  ),
                ),
                PinInput(
                  pinController: _passwordController,
                  label: '',
                  validation: (p0) {},
                ),
                const SizedBox(height: 50),
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () async {
                      if (_authService.isLoading.isFalse) {
                        _authService.pinAuth(
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
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: const Text(
                      'Use password',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
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
