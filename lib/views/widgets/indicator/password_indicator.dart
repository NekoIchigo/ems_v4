import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class PasswordIndicator extends StatefulWidget {
  final IconData firstIcon;
  final IconData secondIcon;
  final IconData thirdIcon;
  final Function() firstOnpress;
  final Function() secondOnpress;
  final Function() thirdOnpress;
  const PasswordIndicator({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.thirdIcon,
    required this.firstOnpress,
    required this.secondOnpress,
    required this.thirdOnpress,
  });

  @override
  State<PasswordIndicator> createState() => _PasswordIndicatorState();
}

class _PasswordIndicatorState extends State<PasswordIndicator>
    with TickerProviderStateMixin {
  late AnimationController _midController;
  late Animation<double> _midAnimation;
  late Animation<Color?> _midBackgroundColorAnimation;
  late Animation<Color?> _midIconColorAnimation;

  late AnimationController _lastController;
  late Animation<double> _lastAnimation;
  late Animation<Color?> _lastBackgroundColorAnimation;
  late Animation<Color?> _lastIconColorAnimation;

  @override
  void initState() {
    super.initState();

    _midController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _midAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_midController);

    _midBackgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: bgPrimaryBlue,
    ).animate(_midController);

    _midIconColorAnimation = ColorTween(
      begin: bgPrimaryBlue,
      end: Colors.white,
    ).animate(_midController);

    _lastController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _lastAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_lastController);

    _lastBackgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: bgPrimaryBlue,
    ).animate(_lastController);

    _lastIconColorAnimation = ColorTween(
      begin: bgPrimaryBlue,
      end: Colors.white,
    ).animate(_lastController);

    // _lastController.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     _midController.reverse();
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
                widget.firstOnpress();
                _midController.reverse();
                _lastController.reverse();
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
                  animation: _midAnimation,
                  builder: (context, child) {
                    return Row(
                      children: [
                        Container(
                          height: 5.0,
                          width: _midAnimation.value * 25.0,
                          color: bgPrimaryBlue,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _midAnimation,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: () {
                    widget.secondOnpress();
                    if (_midController.status != AnimationStatus.completed) {
                      _midController.reset();
                      _midController.forward();
                    }
                    _lastController.reverse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _midBackgroundColorAnimation.value,
                  ),
                  child: Icon(
                    widget.secondIcon,
                    color: _midIconColorAnimation.value,
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
                  animation: _lastAnimation,
                  builder: (context, child) {
                    return Row(
                      children: [
                        Container(
                          height: 5.0,
                          width: _lastAnimation.value * 25.0,
                          color: bgPrimaryBlue,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            AnimatedBuilder(
              animation: _lastBackgroundColorAnimation,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: () {
                    widget.thirdOnpress();
                    if (_lastController.status != AnimationStatus.completed) {
                      _lastController.reset();
                      _lastController.forward();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _lastBackgroundColorAnimation.value,
                  ),
                  child: Icon(
                    widget.thirdIcon,
                    color: _lastIconColorAnimation.value,
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
    _midController.dispose();
    _lastController.dispose();
    super.dispose();
  }
}
