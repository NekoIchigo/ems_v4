import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/edit_profile.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/employee_details.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: Get.height * .75,
              child: ListView(
                children: [
                  const EditProfile(),
                  const SizedBox(height: 10),
                  const EmployeeDetailsWidget(),
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
          ],
        ),
      ),
    );
  }
}
