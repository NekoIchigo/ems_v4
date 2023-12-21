
import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/views/layout/private/home/widgets/health_declaration.dart';
import 'package:ems_v4/views/layout/private/home/widgets/in_out_page.dart';
import 'package:ems_v4/views/layout/private/home/widgets/information.dart';
import 'package:ems_v4/views/layout/private/home/widgets/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageContiner extends StatelessWidget {
  const HomePageContiner({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      switch (homeController.pageName.value) {
        case '/home/info':
          return const HomeInfoPage();
        case '/home/result':
          return const HomeResultPage();
        case '/home/health_declaration':
          return const HealthDeclaration();
        default:
          return const InOutPage();
      }
    });
  }
}
