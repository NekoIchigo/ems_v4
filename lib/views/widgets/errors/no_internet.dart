import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoInternet extends StatelessWidget {
  final String? path;
  const NoInternet({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                left: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/login_bg_image.jpg',
                  opacity: const AlwaysStoppedAnimation(0.6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * .15),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          'assets/images/no_internet.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No connection',
                      style: TextStyle(color: darkGray, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: size.width * .8,
                      child: const Text(
                        'We\'ll need your location to give you a better experience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: darkGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    RoundedCustomButton(
                      onPressed: () {
                        context.go(path ?? '/');
                      },
                      label: 'Try Again',
                      size: Size(size.width * .8, 50),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
