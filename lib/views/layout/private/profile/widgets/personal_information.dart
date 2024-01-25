import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/profile_page_caontainer.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer(
      title: "Change Password",
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
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: lightGray, width: 1.5),
                          shape: BoxShape.circle,
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.grey,
                          //     offset: Offset(0, 5),
                          //     blurRadius: 6,
                          //     spreadRadius: 0,
                          //   ),
                          // ],
                        ),
                        child: const Icon(
                          Icons.image_search,
                          size: 30,
                          color: gray,
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
                    isPassword: true,
                    textController: _contactNumber,
                    labelColor: primaryBlue,
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
                  isPassword: true,
                  textController: _email,
                  labelColor: primaryBlue,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Center(
            child: RoundedCustomButton(
              onPressed: () {},
              label: 'Update',
              radius: 5,
              size: Size(Get.width * .4, 30),
              bgColor: bgPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
