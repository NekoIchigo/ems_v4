import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/layout/private/home/home_container.dart';
import 'package:ems_v4/views/widgets/buttons/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _homeController.getLatestLog(
      employeeId: _authService.employee.value.id,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * .16,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                decoration: const BoxDecoration(
                  color: bgPrimaryBlue,
                ),
                child: Image.asset(
                  'assets/images/EMS_logo.png',
                  height: 50,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Obx(
                  () => Container(
                    alignment: Alignment.center,
                    height: Get.height * .86,
                    decoration: _homeController.isWhite.isTrue
                        ? const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          )
                        : const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/tiles-bg.png'),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * .78,
                          child: _homeController.isLoading.isTrue
                              ? const Loading()
                              : const HomePageContiner(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor: primaryBlue,
    //   body: Center(
    //     child: Obx(
    //       () => Text(
    //         DateFormat("hh:mm a").format(
    //           _settings.currentTime.value,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}