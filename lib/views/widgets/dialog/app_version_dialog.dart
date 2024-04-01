import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/web_view_launcher.dart';
import 'package:flutter/material.dart';

class AppVersionDialog extends StatelessWidget {
  final String? version;
  final String? url;
  const AppVersionDialog({super.key, this.version, this.url});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * .8,
        height: size.height * .7,
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
              "Update Available",
              style: TextStyle(
                color: gray,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              version ?? "1.0.0",
              style: const TextStyle(color: gray),
            ),
            Image.asset('assets/images/maintenance.jpg'),
            SizedBox(
              width: size.width * .6,
              child: const Text(
                "To Continue using the GEMS: Time and Attendance app, you must update the latest version",
                textAlign: TextAlign.center,
                style: TextStyle(color: gray, fontSize: 14),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
              ),
              onPressed: () {
                webViewLauncher(
                  url: url ?? '',
                  errorMessage:
                      'Something went wrong! \n Please update the app in Play Store or App Store',
                );
              },
              child: const Text("Okay", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
