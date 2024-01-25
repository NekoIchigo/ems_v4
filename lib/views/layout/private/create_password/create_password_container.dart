import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/indicator/password_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePasswordContainer extends StatefulWidget {
  const CreatePasswordContainer({super.key});

  @override
  State<CreatePasswordContainer> createState() =>
      _CreatePasswordContainerState();
}

class _CreatePasswordContainerState extends State<CreatePasswordContainer> {
  final CreatePasswordController _passwordController =
      Get.find<CreatePasswordController>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: Get.height * .05),
            Obx(
              () => Text(
                _passwordController.titles[_passwordController.pageIndex.value],
                style: const TextStyle(color: primaryBlue, fontSize: 24),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: Get.width * .6,
              child: Obx(
                () => Text(
                  _passwordController
                      .subtitles[_passwordController.pageIndex.value],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: gray, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PasswordIndicator(
              firstIcon: Icons.edit_note_rounded,
              secondIcon: Icons.security,
              thirdIcon: Icons.fingerprint_rounded,
              firstOnpress: () {},
              secondOnpress: () {},
              thirdOnpress: () {},
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: Get.height * .55,
              child: PageView(
                controller: _passwordController.pageController,
                children: List.generate(_passwordController.pages.length,
                    (index) => _passwordController.pages[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
