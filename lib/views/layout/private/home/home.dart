import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/views/layout/private/home/home_container.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/loader/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: Obx(
        () => Container(
          decoration: _homeController.isWhite.isTrue
              ? const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                )
              : const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tiles-bg.png'),
                    fit: BoxFit.fill,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * .80,
                child: _homeController.isLoading.isFalse
                    ? const HomePageContiner()
                    // Navigator(
                    //     key: Get.nestedKey(_homeController.routerKey),
                    //     onGenerateRoute: (settings) {
                    //       return GetPageRoute(
                    //         page: () => _homeController
                    //             .pages[_homeController.pageIndex.value],
                    //       );
                    //     },
                    //   )

                    : const Loading(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
