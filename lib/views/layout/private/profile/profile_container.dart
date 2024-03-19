import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_list_button.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
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
  final AuthController authService = Get.find<AuthController>();
  bool switchVal = true;

  @override
  initState() {
    super.initState();
    initLocalStorage();
  }

  Future initLocalStorage() async {
    _localStorage = await SharedPreferences.getInstance();
    bool? data = _localStorage.getBool('auth_biometrics');
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
            ProfileListButton(
              label: 'Employment Details',
              onPressed: () {
                Get.toNamed("/profile/employment_details");
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
              label: 'Enable Fingerprint Authentication',
              onPressed: () {
                setState(() {
                  switchVal = !switchVal;
                });
                updateFingerprintState(switchVal);
              },
              leading: SizedBox(
                width: 40,
                child: FittedBox(
                  child: Switch(
                    value: switchVal,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState(() {
                        switchVal = value;
                      });
                      updateFingerprintState(switchVal);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Help Center',
              onPressed: () {
                _launchInBrowser(
                    'https://sites.google.com/view/gemshelpcenter/home');
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Privacy Policy',
              onPressed: () {
                _launchInBrowser(
                    'https://gems.globalland.com.ph/privacy-policy');
              },
            ),
            const SizedBox(height: 5),
            ProfileListButton(
              label: 'Terms of Use',
              onPressed: () {
                _launchInBrowser('https://gems.globalland.com.ph/terms-of-use');
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
    _localStorage.setBool('auth_biometrics', value);
    Get.dialog(
      barrierDismissible: false,
      GemsDialog(
        type: 'success',
        title: 'Success',
        hasMessage: true,
        message: value
            ? "You can now log in using your fingerprint."
            : "Your fingerprint login has been successfully disabled.",
        buttonNumber: 0,
        hasCustomWidget: false,
        withCloseButton: true,
        okButtonBGColor: bgPrimaryBlue,
      ),
    );
  }

  Future<void> _launchInBrowser(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
