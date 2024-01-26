import 'package:ems_v4/controller/create_password_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordIndicator extends StatefulWidget {
  final IconData firstIcon;
  final IconData secondIcon;
  final IconData thirdIcon;
  final Function() firstOnpress;
  final Function() secondOnpress;
  final Function() thirdOnpress;
  final bool? hasNavigation;
  const PasswordIndicator({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.thirdIcon,
    required this.firstOnpress,
    required this.secondOnpress,
    required this.thirdOnpress,
    this.hasNavigation,
  });

  @override
  State<PasswordIndicator> createState() => _PasswordIndicatorState();
}

class _PasswordIndicatorState extends State<PasswordIndicator>
    with TickerProviderStateMixin {
  final CreatePasswordController _passwordController =
      Get.find<CreatePasswordController>();

  @override
  void initState() {
    super.initState();

    _passwordController.midController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    ).obs;

    _passwordController.midAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_passwordController.midController.value).obs;

    _passwordController.midBackgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: bgPrimaryBlue,
    ).animate(_passwordController.midController.value).obs;

    _passwordController.midIconColorAnimation = ColorTween(
      begin: bgPrimaryBlue,
      end: Colors.white,
    ).animate(_passwordController.midController.value).obs;

    _passwordController.lastController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    ).obs;

    _passwordController.lastAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_passwordController.lastController.value).obs;

    _passwordController.lastBackgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: bgPrimaryBlue,
    ).animate(_passwordController.lastController.value).obs;

    _passwordController.lastIconColorAnimation = ColorTween(
      begin: bgPrimaryBlue,
      end: Colors.white,
    ).animate(_passwordController.lastController.value).obs;

    // _passwordController.lastController.value.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     _passwordController.midController.value.reverse();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (widget.hasNavigation ?? true) {
                  widget.firstOnpress();
                  _passwordController.animateReturnToFirstPage();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bgPrimaryBlue,
              ),
              child: Icon(
                widget.firstIcon,
                color: Colors.white,
                size: 25,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                AnimatedBuilder(
                  animation: _passwordController.midAnimation.value,
                  builder: (context, child) {
                    return Row(
                      children: [
                        Container(
                          height: 5.0,
                          width: _passwordController.midAnimation.value.value *
                              25.0,
                          color: bgPrimaryBlue,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _passwordController.midAnimation.value,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (widget.hasNavigation ?? true) {
                      _passwordController.animateToSecondPage();
                      widget.secondOnpress();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _passwordController
                        .midBackgroundColorAnimation.value.value,
                  ),
                  child: Icon(
                    widget.secondIcon,
                    color:
                        _passwordController.midIconColorAnimation.value.value,
                    size: 25,
                  ),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                AnimatedBuilder(
                  animation: _passwordController.lastAnimation.value,
                  builder: (context, child) {
                    return Row(
                      children: [
                        Container(
                          height: 5.0,
                          width: _passwordController.lastAnimation.value.value *
                              25.0,
                          color: bgPrimaryBlue,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _passwordController.lastBackgroundColorAnimation.value,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (widget.hasNavigation ?? true) {
                      if (_passwordController.pageIndex.value == 1) {
                        _passwordController.animateToThirdPage();
                        widget.thirdOnpress();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _passwordController
                        .lastBackgroundColorAnimation.value.value,
                  ),
                  child: Icon(
                    widget.thirdIcon,
                    color:
                        _passwordController.lastIconColorAnimation.value.value,
                    size: 25,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.midController.value.dispose();
    _passwordController.lastController.value.dispose();
    super.dispose();
  }
}
