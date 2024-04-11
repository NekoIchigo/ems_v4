import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPIN extends StatefulWidget {
  const NewPIN({super.key});

  @override
  State<NewPIN> createState() => _NewPINState();
}

class _NewPINState extends State<NewPIN> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? errorText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Set New Pin",
              style: TextStyle(
                color: primaryBlue,
                fontSize: 15,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New PIN",
                style: TextStyle(color: primaryBlue),
              ),
              PinInput(
                pinController: _passwordController,
                label: '',
                errorText: errorText,
                hasShadow: true,
                validation: (p0) {},
              ),
              const SizedBox(height: 30),
              const Text(
                "Re-enter PIN",
                style: TextStyle(color: primaryBlue),
              ),
              PinInput(
                pinController: _confirmPasswordController,
                label: '',
                hasShadow: true,
                validation: (value) {
                  if (_passwordController.text != value) {
                    return 'PIN not match';
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          Obx(
            () => RoundedCustomButton(
              isLoading: _createPasswordController.isLoading.value,
              onPressed: () async {
                _createPasswordController.isForgotPin.value = true;
                var error = await _createPasswordController.changePIN(
                  _passwordController.text,
                  _confirmPasswordController.text,
                );

                errorText = error['message'];
                setState(() {});
              },
              label: _createPasswordController.isLoading.isTrue
                  ? "Submitting..."
                  : "Submit",
              size: Size(size.width * .9, 40),
              bgColor: bgPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
