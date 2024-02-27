import 'package:ems_v4/global/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final AuthService authService = Get.find<AuthService>();

  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    return authService.authenticated.value
        ? null
        : const RouteSettings(name: '/login');
  }
}
