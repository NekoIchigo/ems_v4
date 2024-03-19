import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class EMSContainer extends StatefulWidget {
  final Widget child;
  const EMSContainer({super.key, required this.child});

  @override
  State<EMSContainer> createState() => _EMSContainerState();
}

class _EMSContainerState extends State<EMSContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              height: size.height * .16,
              padding:
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 35),
              color: bgPrimaryBlue,
            ),
            Positioned(
              top: 45,
              left: 10,
              child: Image.asset(
                'assets/images/GEMS4white.png',
                height: 45,
              ),
            ),
            Positioned(
              top: (size.height * .12) -
                  (MediaQuery.of(context).viewInsets.bottom * .3),
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * .87,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
