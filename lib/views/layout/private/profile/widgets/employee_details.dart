import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({super.key});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage>
    with SingleTickerProviderStateMixin {
  final AuthController _authService = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 5,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    "Employment Details",
                    style: TextStyle(
                      color: bgSecondaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Company",
                  style: TextStyle(
                    color: bgSecondaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _authService.company.value.name,
                  style: defaultStyle,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Department",
                  style: TextStyle(
                    color: bgSecondaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _authService.employee!.value.employeeDetails.department.name,
                  style: defaultStyle,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Position",
                  style: TextStyle(
                    color: bgSecondaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _authService.employee!.value.employeeDetails.position.name,
                  style: defaultStyle,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Date Hired",
                  style: TextStyle(
                    color: bgSecondaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _authService.employee?.value.employeeDetails.dateHired ??
                      "??/??/????",
                  style: defaultStyle,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Employee ID",
                  style: TextStyle(
                    color: bgSecondaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _authService.employee!.value.employeeDetails.employeeNumber,
                  style: defaultStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
