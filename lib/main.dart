import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/controller/profile_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    Get.put(AuthController());
    Get.put(TimeEntriesController());
    Get.put(MainNavigationController());
    Get.put(TransactionController());
    Get.put(CreatePasswordController());
    Get.put(ProfileController());
    Get.put(HomeController());
    Get.put(DTRCorrectionController());

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: bgPrimaryBlue,
        ),
        useMaterial3: true,
      ),
    );
  }
}
