import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/indicator/password_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordContainer extends StatefulWidget {
  const ForgotPasswordContainer({super.key});

  @override
  State<ForgotPasswordContainer> createState() =>
      _ForgotPasswordContainerState();
}

class _ForgotPasswordContainerState extends State<ForgotPasswordContainer> {
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
    return EMSContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                    )),
              ),
            ),
            const Text(
              "Forgot Password",
              style: TextStyle(color: primaryBlue, fontSize: 24),
            ),
            const SizedBox(height: 20),
            PasswordIndicator(
              hasNavigation: false,
              firstIcon: Icons.email,
              secondIcon: Icons.security,
              thirdIcon: Icons.lock,
              firstOnpress: () {},
              secondOnpress: () {},
              thirdOnpress: () {},
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: Get.height * .55,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _passwordController.pageController.value,
                children: List.generate(
                  _passwordController.forgotPasswordPages.length,
                  (index) => _passwordController.forgotPasswordPages[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Asd123456*