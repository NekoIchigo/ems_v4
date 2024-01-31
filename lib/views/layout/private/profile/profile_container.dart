import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_list_button.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/get_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  late SharedPreferences _localStorage;
  final AuthService authService = Get.find<AuthService>();
  bool switchVal = true;

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  initState() {
    super.initState();
    initLocalStorage();
  }

  Future initLocalStorage() async {
    _localStorage = await SharedPreferences.getInstance();
    bool? data = _localStorage.getBool('auth_biometrics');
    print(data);
    setState(() {
      switchVal = data ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Accounts and Profile Info",
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            ProfileListButton(
              label: 'Personal Information',
              onPressed: () {
                Get.toNamed("/profile/personal_info");
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Change Password',
              onPressed: () {
                Get.toNamed("/profile/change_password");
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Change PIN',
              onPressed: () {
                Get.toNamed("/profile/change_pin");
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Enable Fingerprint Authetication',
              onPressed: () {
                setState(() {
                  switchVal = !switchVal;
                });
                updateFingerprintState(switchVal);
              },
              leading: Switch(
                value: switchVal,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    switchVal = value;
                  });
                  updateFingerprintState(switchVal);
                },
              ),
            ),
            ProfileListButton(
              label: 'Employment Details',
              onPressed: () {
                Get.toNamed("/profile/employment_details");
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Privacy Policy',
              onPressed: () {
                _launchInBrowser(
                    'https://happyhousekeepers.com.ph/privacy-policy');
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Terms of Use',
              onPressed: () {
                _launchInBrowser(
                    'https://happyhousekeepers.com.ph/privacy-policy');
              },
            ),
            const SizedBox(height: 30),
            RoundedCustomButton(
              onPressed: () {
                if (authService.isLoading.isFalse) {
                  authService.logout();
                }
              },
              label: 'Log out',
              size: Size(Get.width, 30),
              bgColor: bgPrimaryBlue,
            ),
          ],
        ),
      ),
    );
  }

  updateFingerprintState(bool value) {
    print(value);
    _localStorage.setBool('auth_biometrics', value);
    Get.dialog(
      barrierDismissible: false,
      GetDialog(
        type: 'success',
        title: 'Fingerprint Authetication Updated',
        hasMessage: false,
        message: "You can now log in using your new password.",
        buttonNumber: 1,
        hasCustomWidget: false,
        withCloseButton: false,
        okPress: () {
          Get.back();
        },
        okText: "Close",
        okButtonBGColor: bgPrimaryBlue,
      ),
    );
  }
}
