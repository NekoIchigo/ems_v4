import 'package:ems_v4/views/layout/private/create_password/create_password_container.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/private/home/widgets/health_declaration.dart';
import 'package:ems_v4/views/layout/private/home/widgets/in_out_page.dart';
import 'package:ems_v4/views/layout/private/home/widgets/information.dart';
import 'package:ems_v4/views/layout/private/home/widgets/result.dart';
import 'package:ems_v4/views/layout/private/main_navigation.dart';
import 'package:ems_v4/views/layout/private/notification/notification_page.dart';
import 'package:ems_v4/views/layout/private/profile/profile.dart';
import 'package:ems_v4/views/layout/private/profile/profile_container.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/change_password.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/change_pin.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/employee_details.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/personal_information.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/attendance_log.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/time_entries_health_declaration.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/time_entries_index.dart';
import 'package:ems_v4/views/layout/private/transactions/transactions.dart';
import 'package:ems_v4/views/layout/public/forgot_password/forgot_password_container.dart';
import 'package:ems_v4/views/layout/public/forgot_pin/forgot_pin_container.dart';
import 'package:ems_v4/views/layout/public/login.dart';
import 'package:ems_v4/views/layout/public/pin_login.dart';
import 'package:ems_v4/views/layout/public/splash_screen.dart';
import 'package:ems_v4/views/widgets/errors/no_internet.dart';
import 'package:ems_v4/views/widgets/errors/no_location_permission.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child),
  );
}

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/no-permission',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: const NoLocationPermission()),
    ),
    GoRoute(
      path: '/no-internet',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: NoInternet()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: const Login()),
    ),
    GoRoute(
      path: '/pin_login',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: const PINLogin()),
    ),
    GoRoute(
      path: '/forgot_password',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const ForgotPasswordContainer()),
    ),
    GoRoute(
      path: '/forgot_pin',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context, state: state, child: const ForgotPINContainer()),
    ),
    GoRoute(
        path: '/create_password',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const CreatePasswordContainer())),
    ShellRoute(
      pageBuilder: (context, state, child) =>
          buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: MainNavigation(child: child)),
      routes: [
        ShellRoute(
          pageBuilder: (context, state, child) =>
              buildPageWithDefaultTransition<void>(
                  context: context, state: state, child: Home(child: child)),
          routes: [
            GoRoute(
              path: '/in_out',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const InOutPage(),
              ),
            ),
            GoRoute(
              path: '/info',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const HomeInfoPage(),
              ),
            ),
            GoRoute(
              path: '/health_declaration',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const HealthDeclaration(),
              ),
            ),
            GoRoute(
              path: '/result',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const HomeResultPage(),
              ),
            ),
          ],
        ),
        ShellRoute(
          pageBuilder: (context, state, child) =>
              buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: TimeEntries(child: child)),
          routes: [
            GoRoute(
              path: '/time_entries',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const TimeEntriesIndex(),
              ),
            ),
            GoRoute(
              path: '/attendance-log',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const AttendanceLog(),
              ),
            ),
            GoRoute(
              path: '/time-entries-health',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const TimeEntriesHealthDeclaration(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/transaction',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
              context: context, state: state, child: const Transactions()),
        ),
        GoRoute(
          path: '/notification',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
              context: context, state: state, child: const NotificationPage()),
        ),
        ShellRoute(
          pageBuilder: (context, state, child) =>
              buildPageWithDefaultTransition<void>(
                  context: context, state: state, child: Profile(child: child)),
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ProfileContainer(),
              ),
            ),
            GoRoute(
              path: '/personal_info',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const PersonalInformation(),
              ),
            ),
            GoRoute(
              path: '/employment_details',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const EmployeeDetailsPage(),
              ),
            ),
            GoRoute(
              path: '/change_password',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ChangePassword(),
              ),
            ),
            GoRoute(
              path: '/change_pin',
              pageBuilder: (context, state) =>
                  buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ChangePin(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
