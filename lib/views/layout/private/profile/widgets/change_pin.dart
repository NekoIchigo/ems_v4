import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({super.key});

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final CreatePasswordController _createPasswordController =
      Get.find<CreatePasswordController>();
  final TextEditingController _currentPin = TextEditingController();
  final TextEditingController _newPin = TextEditingController();
  final TextEditingController _confirmPin = TextEditingController();

  String? errorPin;
  String? currentPin;
  bool isCurrentEmpty = true;

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer(
      title: "Change PIN",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current PIN",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PinInput(
                  pinController: _currentPin,
                  label: '',
                  errorText: currentPin,
                  hasShadow: true,
                  onChanged: (p0) {
                    isCurrentEmpty = false;
                    setState(() {});
                  },
                  validation: (p0) {},
                ),
                const SizedBox(height: 30),
                const Text(
                  "New PIN",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PinInput(
                  readOnly: isCurrentEmpty,
                  pinController: _newPin,
                  errorText: errorPin,
                  label: '',
                  hasShadow: true,
                  validation: (p0) {},
                ),
                const SizedBox(height: 30),
                const Text(
                  "Re-enter PIN",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PinInput(
                  pinController: _confirmPin,
                  readOnly: isCurrentEmpty,
                  label: '',
                  hasShadow: true,
                  validation: (value) {
                    if (_newPin.text != value) {
                      return 'PIN not match';
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Center(
            child: RoundedCustomButton(
              onPressed: () async {
                if (_currentPin.text != '') {
                  var error = await _createPasswordController.changePIN(
                    _newPin.text,
                    _confirmPin.text,
                    currentpin: _currentPin.text,
                  );
                  if (error != null) {
                    if (error['errors'].containsKey('pin')) {
                      errorPin = error['errors']['pin'][0];
                    }
                  } else {
                    currentPin = error['message'];
                  }
                  setState(() {});
                }
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
