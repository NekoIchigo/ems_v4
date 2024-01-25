import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_list_button.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  final AuthService authService = Get.find<AuthService>();
  bool switchVal = true;

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
              "Accounts and Proflie Info",
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            ProfileListButton(
              label: 'Personal Information',
              onPressed: () {},
            ),
            ProfileListButton(
              label: 'Change Password',
              onPressed: () {},
            ),
            ProfileListButton(
              label: 'Change PIN',
              onPressed: () {},
            ),
            ProfileListButton(
              label: 'Enable Fingerprint Authetication',
              onPressed: () {
                setState(() {
                  switchVal = !switchVal;
                });
              },
              leading: Switch(
                value: switchVal,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  setState(() {
                    switchVal = value;
                  });
                },
              ),
            ),
            ProfileListButton(
              label: 'Employment Details',
              onPressed: () {},
            ),
            ProfileListButton(
              label: 'Provacy Policy',
              onPressed: () {},
            ),
            ProfileListButton(
              label: 'Terms of Use',
              onPressed: () {},
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
}
