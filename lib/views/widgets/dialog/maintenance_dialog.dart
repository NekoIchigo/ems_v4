import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .8,
        height: size.height * .6,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Under Maintenance",
              style: TextStyle(
                color: gray,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.asset('assets/images/maintenance.jpg'),
            SizedBox(
              width: size.width * .7,
              child: const Text(
                "The page you're looking for is currently under maintenance and will be back soon.",
                textAlign: TextAlign.center,
                style: TextStyle(color: gray, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
