import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final AuthController authService = Get.find<AuthController>();

  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    return authService.authenticated.value
        ? null
        : const RouteSettings(name: '/login');
  }
}
