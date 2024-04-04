import 'package:ems_v4/global/constants.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Allow "GEMS" to access your location \n while using the app?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gray,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/no_location_permission.jpg',
              width: 250,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop([false]);
                  },
                  child: const Text(
                    "DENY",
                    style:
                        TextStyle(color: darkGray, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop([true]);
                  },
                  child: const Text(
                    "ACCEPT",
                    style: TextStyle(
                        color: bgPrimaryBlue, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
