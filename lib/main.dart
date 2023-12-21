import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/guards/auth_guard.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/services/settings.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/public/login.dart';
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
    Get.put(HomeController());
    // Get.put(TimeEntriesController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: bgPrimaryBlue,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const Login()),
        GetPage(
            name: '/home',
            page: () => const Home(),
            middlewares: [AuthGuard()]),
      ],
    );
  }
}
