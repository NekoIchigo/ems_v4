import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NoLocationPermission extends StatelessWidget {
  const NoLocationPermission({super.key});

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
                child: Image.asset('assets/images/login_bg_image.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * .15),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          'assets/images/no_location_permisison.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Enable Location'),
                    const Text(
                        'We\'ll need your location to give you a better experience'),
                    RoundedCustomButton(
                      onPressed: () {
                        Geolocator.openLocationSettings();
                      },
                      label: 'Go to Settings',
                      size: Size(size.width * .8, 50),
                    )
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
