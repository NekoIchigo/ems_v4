import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
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
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker picker = ImagePicker();
  bool isNotEdit = true;
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactNumber
        .setText(_authService.employee.value.employeeContact.contactNumber);
    _email.setText(_authService.employee.value.employeeContact.email);
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
                      OutlinedButton(
                        onPressed: () async {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          print(image);
                        },
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.all(0),
                            side: const BorderSide(
                              color: lightGray,
                            )),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.image_search,
                            size: 30,
                            color: gray,
                          ),
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
                    isPassword: false,
                    disabled: isNotEdit,
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
                  isPassword: false,
                  disabled: isNotEdit,
                  textController: _email,
                  labelColor: primaryBlue,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Center(
            child: RoundedCustomButton(
              onPressed: () {
                setState(() {
                  isNotEdit = false;
                });
              },
              label: isNotEdit ? 'Update' : 'Submit',
              radius: 5,
              size: Size(Get.width * .35, 30),
              bgColor: bgPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
