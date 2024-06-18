import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/change_restday_controller.dart';
import 'package:ems_v4/global/controller/change_schedule_controller.dart';
import 'package:ems_v4/global/controller/create_password_controller.dart';
import 'package:ems_v4/global/controller/dtr_correction_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/controller/leave_controller.dart';
import 'package:ems_v4/global/controller/main_navigation_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/controller/overtime_controller.dart';
import 'package:ems_v4/global/controller/profile_controller.dart';
import 'package:ems_v4/global/controller/setting_controller.dart';
import 'package:ems_v4/global/controller/time_entries_controller.dart';
import 'package:ems_v4/global/controller/timre_records_controller.dart';
import 'package:ems_v4/global/controller/transaction_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/router/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
    Get.put(OvertimeController());
    Get.put(ChangeScheduleController());
    Get.put(LeaveController());
    Get.put(ChangeRestdayController());
    Get.put(DTRCorrectionController());
    Get.put(MessageController());
    Get.put(TimeRecordsController());

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
