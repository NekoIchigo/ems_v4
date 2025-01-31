import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EMSContainer extends StatefulWidget {
  final Widget child;
  const EMSContainer({super.key, required this.child});

  @override
  State<EMSContainer> createState() => _EMSContainerState();
}

class _EMSContainerState extends State<EMSContainer> {
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();

  late DateTime currentTime;
  late String greetings;

  @override
  void initState() {
    super.initState();
    currentTime = _settings.currentTime.value;
    greetings = _dateTimeUtils.getGreeting(currentTime.hour);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Unfocus any text field when tapping outside of them
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
                top: 55,
                left: 10,
                child: Image.asset(
                  'assets/images/GEMS4white.png',
                  height: 40,
                ),
              ),
              Positioned(
                top: 65,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      '$greetings ',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${_auth.employee!.value.firstName}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: (size.height * .128) -
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
      ),
    );
  }
}
