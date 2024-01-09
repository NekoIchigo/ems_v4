import 'package:auto_route/auto_route.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/router/app_router.dart';
import 'package:get/get.dart';

class AuthGuard extends AutoRouteGuard {
  AuthService _authService = Get.find<AuthService>();
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authService.autheticated.value) {
      resolver.next(true);
    } else {
      resolver.redirect(const Login());
    }
  }
}
