import 'package:ems_v4/global/controller/create_password_controller.dart';
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
  void initState() {
    super.initState();
    _passwordController.pageController.value = PageController(initialPage: 0);
    _passwordController.pageController.value.addListener(() {
      int newPage = _passwordController.pageController.value.page?.round() ?? 0;
      if (newPage == 1) {
        if (_passwordController.midController.value.status !=
            AnimationStatus.completed) {
          _passwordController.midController.value.reset();
          _passwordController.midController.value.forward();
        }
        _passwordController.lastController.value.reverse();
      } else if (newPage == 2 &&
          _passwordController.lastController.value.status !=
              AnimationStatus.completed) {
        _passwordController.lastController.value.reset();
        _passwordController.lastController.value.forward();
      } else if (newPage == 0) {
        _passwordController.midController.value.reverse();
        _passwordController.lastController.value.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return EMSContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: size.height * .05),
            Obx(
              () => Text(
                _passwordController.titles[_passwordController.pageIndex.value],
                style: const TextStyle(color: bgSecondaryBlue, fontSize: 24),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: size.width * .6,
              child: Obx(
                () => Text(
                  _passwordController
                      .subtitles[_passwordController.pageIndex.value],
                  textAlign: TextAlign.center,
                  style: smallStyle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            PasswordIndicator(
              hasNavigation: true,
              firstIcon: Icons.edit_note_rounded,
              secondIcon: Icons.security,
              thirdIcon: Icons.fingerprint_rounded,
              firstOnpress: () {},
              secondOnpress: () {},
              thirdOnpress: () {},
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: size.height * .55,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _passwordController.pageController.value,
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
