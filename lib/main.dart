import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/services/settings.dart';
import 'package:ems_v4/views/layout/public/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

