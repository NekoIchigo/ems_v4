import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/views/widgets/loader/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final Widget child;

  Home({super.key, required this.child});
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * .80,
          child: _homeController.isLoading.isFalse ? child : const Loading(),
        ),
      ],
    );
  }
}
