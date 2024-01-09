// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomePage.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Home(),
      );
    },
    Login.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Login(),
      );
    },
    MainRouterPage.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainNavigation(),
      );
    },
    NotifPage.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPage(),
      );
    },
    ProfilePage.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Profile(),
      );
    },
    TimeEntries.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimeEntries(),
      );
    },
    Transactions.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Transactions(),
      );
    },
  };
}

/// generated route for
/// [Home]
class HomePage extends PageRouteInfo<void> {
  const HomePage({List<PageRouteInfo>? children})
      : super(
          HomePage.name,
          initialChildren: children,
        );

  static const String name = 'HomePage';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Login]
class Login extends PageRouteInfo<void> {
  const Login({List<PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainNavigation]
class MainRouterPage extends PageRouteInfo<void> {
  const MainRouterPage({List<PageRouteInfo>? children})
      : super(
          MainRouterPage.name,
          initialChildren: children,
        );

  static const String name = 'MainRouterPage';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationPage]
class NotifPage extends PageRouteInfo<void> {
  const NotifPage({List<PageRouteInfo>? children})
      : super(
          NotifPage.name,
          initialChildren: children,
        );

  static const String name = 'NotifPage';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Profile]
class ProfilePage extends PageRouteInfo<void> {
  const ProfilePage({List<PageRouteInfo>? children})
      : super(
          ProfilePage.name,
          initialChildren: children,
        );

  static const String name = 'ProfilePage';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimeEntries]
class TimeEntries extends PageRouteInfo<void> {
  const TimeEntries({List<PageRouteInfo>? children})
      : super(
          TimeEntries.name,
          initialChildren: children,
        );

  static const String name = 'TimeEntries';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Transactions]
class Transactions extends PageRouteInfo<void> {
  const Transactions({List<PageRouteInfo>? children})
      : super(
          Transactions.name,
          initialChildren: children,
        );

  static const String name = 'Transactions';

  static const PageInfo<void> page = PageInfo<void>(name);
}
