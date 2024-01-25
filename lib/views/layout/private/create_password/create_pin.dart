import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePin extends StatefulWidget {
  const CreatePin({super.key});

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  final CreatePasswordController _passwordController =
      Get.find<CreatePasswordController>();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PinInput(
          pinController: pinController,
          label: "New PIN",
          validation: (p0) {},
        ),
        const SizedBox(height: 20),
        PinInput(
          pinController: confirmPinController,
          label: "Confirm PIN",
          validation: (p0) {},
        ),
        const SizedBox(height: 40),
        Align(
          alignment: Alignment.bottomCenter,
          child: RoundedCustomButton(
            onPressed: () {
              _passwordController.animateToThirdPage();
            },
            label: "Next",
            size: Size(Get.width * .9, 40),
            bgColor: bgPrimaryBlue,
          ),
        ),
      ],
    );
  }
}
