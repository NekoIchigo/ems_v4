import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({super.key});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  final AuthService _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
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
                        color: darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Company",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text(_authService.company.value.name),
                  const SizedBox(height: 30),
                  const Text(
                    "Department",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text(_authService
                      .employee.value.employeeDetails.department.name),
                  const SizedBox(height: 30),
                  const Text(
                    "Position",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text(_authService
                      .employee.value.employeeDetails.position.name),
                  const SizedBox(height: 30),
                  const Text(
                    "Date Hired",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text(_authService.employee.value.employeeDetails.dateHired),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
