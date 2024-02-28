import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/controller/profile_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/location_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/services/settings.dart';
import 'package:ems_v4/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // start the authservice and settings
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => Settings().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TimeEntriesController());
    Get.put(LocationController());
    Get.put(MainNavigationController());
    Get.put(TransactionController());
    Get.put(CreatePasswordController());
    Get.put(ProfileController());
    Get.put(HomeController());

    return GetMaterialApp(
      title: 'EMS V.4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: bgPrimaryBlue,
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRouteName,
      getPages: routes,
    );
  }
}
