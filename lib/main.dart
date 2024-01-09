import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/controller/main_navigation_controller.dart';
import 'package:ems_v4/controller/time_entries_controller.dart';
import 'package:ems_v4/controller/location_controller.dart';
import 'package:ems_v4/controller/transaction_controller.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(TimeEntriesController());
    Get.put(LocationController());
    Get.put(TransactionController());
    Get.put(MainNavigationController());

    return MaterialApp.router(
      title: 'EMS V.4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: bgPrimaryBlue,
        ),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
