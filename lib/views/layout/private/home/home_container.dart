import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/views/layout/private/home/widgets/additional_shift_info.dart';
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
        case '/home/additional_shift_info:clock_in':
          return const AdditionalShiftInfo(isClockin: true);
        case '/home/additional_shift_info:clock_out':
          return const AdditionalShiftInfo(isClockin: false);
        default:
          return const InOutPage();
      }
    });
  }
}
