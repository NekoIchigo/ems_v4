import 'dart:convert';

import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/profile_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_container.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final AuthController authService = Get.find<AuthController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  bool isNotEdit = true;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileController.profileImage.value =
        authService.employee!.value.profileBase64;
    _contactNumber.setText(
        authService.employee!.value.employeeContact.workContactNumber ?? '');
    _email.setText(authService.employee!.value.employeeContact.email ?? '');
    _name.setText(
        "${authService.employee!.value.firstName} ${authService.employee!.value.lastName}");
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer(
      title: "Personal Information",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: lightGray),
                              ),
                              child: ClipOval(
                                child: Obx(
                                  () => _profileController.profileImage.value !=
                                          ''
                                      ? Image.memory(
                                          base64.decode(_profileController
                                              .profileImage.value),
                                          fit: BoxFit.contain,
                                        )
                                      : const Icon(
                                          Icons.image_search,
                                          size: 30,
                                          color: gray,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  _profileController.selectProfileImage();
                                },
                                icon: const Icon(
                                  Icons.camera_enhance_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Upload Photo",
                          style: TextStyle(
                            color: gray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Name",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Input(
                    validator: (p0) {},
                    isPassword: false,
                    disabled: true,
                    textController: _name,
                    labelColor: primaryBlue,
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Contact Number",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Input(
                    validator: (p0) {},
                    isPassword: false,
                    disabled: true,
                    textController: _contactNumber,
                    labelColor: primaryBlue,
                    icon: Icons.phone_android_rounded,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Email",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Input(
                  validator: (p0) {},
                  isPassword: false,
                  disabled: true,
                  textController: _email,
                  labelColor: primaryBlue,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
