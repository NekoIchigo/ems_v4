import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationDisclosure extends StatelessWidget {
  const LocationDisclosure({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .8,
        height: size.height * .6,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Give "GEMS" to access your precise location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: gray,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/no_location_permission.png',
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * .65,
                child: const Text(
                  "Your current location will be displayed on the map every time you clock in or out. This will be the basis of your work location.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: gray, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              RoundedCustomButton(
                onPressed: () {
                  context.pop([true]);
                },
                label: "Allow location access",
                bgColor: bgPrimaryBlue,
                size: Size(size.width * .65, 30),
              ),
              RoundedCustomButton(
                onPressed: () {
                  context.pop([false]);
                },
                label: "Not now",
                bgColor: gray,
                size: Size(size.width * .65, 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
