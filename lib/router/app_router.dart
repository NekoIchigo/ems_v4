import 'package:ems_v4/global/guards/auth_guard.dart';
import 'package:ems_v4/views/layout/private/create_password/create_password_container.dart';
import 'package:ems_v4/views/layout/private/home/home.dart';
import 'package:ems_v4/views/layout/private/main_navigation.dart';
import 'package:ems_v4/views/layout/private/notification/notification_page.dart';
import 'package:ems_v4/views/layout/private/profile/profile.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/change_password.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/change_pin.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/employee_details.dart';
import 'package:ems_v4/views/layout/private/profile/widgets/personal_information.dart';
import 'package:ems_v4/views/layout/private/time_entries/time_entries.dart';
import 'package:ems_v4/views/layout/private/transactions/transactions.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/dtr_correction/dtr_corrections.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/menu.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/time_records.dart';
import 'package:ems_v4/views/layout/public/forgot_password/forgot_password_container.dart';
import 'package:ems_v4/views/layout/public/login.dart';
import 'package:get/get.dart';

const String initalRouteName = '/login';

final List<GetPage> routes = [
  GetPage(name: '/login', page: () => const Login()),
  GetPage(
    name: '/forgot_password',
    page: () => const ForgotPasswordContainer(),
  ),
  GetPage(
      name: '/create_password',
      page: () => const CreatePasswordContainer(),
      middlewares: [AuthGuard()]),
  GetPage(
    name: '/',
    page: () => const MainNavigation(),
    middlewares: [AuthGuard()],
    children: [
      GetPage(
        name: '/home',
        page: () => const Home(),
        middlewares: [AuthGuard()],
      ),
      GetPage(
        name: '/time_entries',
        page: () => const TimeEntries(),
        middlewares: [AuthGuard()],
      ),
      GetPage(
        name: '/transactions',
        page: () => const Transactions(),
        middlewares: [AuthGuard()],
        children: [
          GetPage(name: '/menu', page: () => const Menu()),
          GetPage(name: '/time_records', page: () => const TimeRecords()),
          GetPage(name: '/dtr_correction', page: () => const DTRCorrection()),
        ],
      ),
      GetPage(
        name: '/notification',
        page: () => const NotificationPage(),
        middlewares: [AuthGuard()],
      ),
      GetPage(
        name: '/profile',
        page: () => const Profile(),
        middlewares: [AuthGuard()],
        children: [
          GetPage(
            name: '/personal_info',
            page: () => const PersonalInformation(),
          ),
          GetPage(
            name: '/change_password',
            page: () => const ChangePassword(),
          ),
          GetPage(
            name: '/change_pin',
            page: () => const ChangePin(),
          ),
          GetPage(
            name: '/employment_details',
            page: () => const EmployeeDetailsPage(),
          ),
        ],
      ),
    ],
  ),
];
