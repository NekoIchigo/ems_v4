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
              firstOnpress: () {
                _passwordController.pageIndex.value = 0;
                _passwordController.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              secondIcon: Icons.security,
              secondOnpress: () {
                _passwordController.pageIndex.value = 1;
                _passwordController.pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              thirdIcon: Icons.fingerprint_rounded,
              thirdOnpress: () {
                _passwordController.pageIndex.value = 2;
                _passwordController.pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: Get.height * .55,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
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
