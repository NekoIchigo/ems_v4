import 'package:ems_v4/views/layout/private/create_password/create_password_container.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/private/main_navigation.dart';
import 'package:ems_v4/views/layout/private/notification/notification_page.dart';
import 'package:ems_v4/views/layout/private/profile/profile.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries.dart';
import 'package:ems_v4/views/layout/private/transactions/transactions.dart';
import 'package:ems_v4/views/layout/public/forgot_password/forgot_password_container.dart';
import 'package:ems_v4/views/layout/public/forgot_pin/forgot_pin_container.dart';
import 'package:ems_v4/views/layout/public/login.dart';
import 'package:ems_v4/views/layout/public/pin_login.dart';
import 'package:ems_v4/views/layout/public/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/pin_login', builder: (context, state) => const PINLogin()),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordContainer(),
    ),
    GoRoute(
      path: '/forgot_pin',
      builder: (context, state) => const ForgotPINContainer(),
    ),
    GoRoute(
        path: '/create_password',
        builder: (context, state) => const CreatePasswordContainer()),
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigation(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const Home(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/time_entries',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const TimeEntries(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/transaction',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const Transactions(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/notification',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const NotificationPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const Profile(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    // GoRoute(
    //   path: '/main',
    //   builder: (context, state) => const MainNavigation(),
    //   routes: [
    //     GoRoute(
    //       path: 'home',
    //       builder: (context, state) => const Home(),
    //     ),
    //     GoRoute(
    //       path: 'time_entries',
    //       builder: (context, state) => const TimeEntries(),
    //     ),
    //     GoRoute(
    //       path: 'transaction',
    //       builder: (context, state) => const Transactions(),
    //     ),
    //     GoRoute(
    //       path: 'notification',
    //       builder: (context, state) => const NotificationPage(),
    //     ),
    //     GoRoute(
    //       path: 'profile',
    //       builder: (context, state) => const Profile(),
    //     ),
    //   ],
    // ),
  ],
);
