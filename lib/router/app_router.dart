import 'package:auto_route/auto_route.dart';
import 'package:ems_v4/router/guard.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        //HomeScreen is generated as HomeRoute because
        //of the replaceInRouteName property
        AutoRoute(
          page: MainNavigation.page,
          path: '/',
          guards: [AuthGuard()],
        ),
        AutoRoute(page: Login.page, path: '/login'),
      ];
}
