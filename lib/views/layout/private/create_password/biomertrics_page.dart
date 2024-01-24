import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BiometricsPage extends StatefulWidget {
  const BiometricsPage({super.key});

  @override
  State<BiometricsPage> createState() => _BiometricsPageState();
}

class _BiometricsPageState extends State<BiometricsPage> {
  bool _switch = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: lightGray),
              borderRadius: BorderRadius.circular(5),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.grey,
              //     offset: Offset(0, 3),
              //     blurRadius: 2,
              //     spreadRadius: 0,
              //   ),
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enable Biometrics Log in ",
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 5),
                Switch(
                  value: _switch,
                  onChanged: (value) {
                    setState(() {
                      _switch = value;
                    });
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "You can turn this feature on or off at any time under My Account.",
            textAlign: TextAlign.center,
            style: TextStyle(color: primaryBlue),
          ),
          const SizedBox(height: 40),
          const Text(
            "By submitting, you agree to our Privacy Policy and Terms of Use.",
            textAlign: TextAlign.center,
            style: TextStyle(color: gray),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomCenter,
            child: RoundedCustomButton(
              onPressed: () {
                Get.offNamed('/');
              },
              label: "Submit",
              size: Size(Get.width * .8, 40),
              bgColor: bgPrimaryBlue,
            ),
          )
        ],
      ),
    );
  }
}
