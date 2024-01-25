import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({super.key});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage>
    with SingleTickerProviderStateMixin {
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Employment Details",
                      style: TextStyle(
                        color: darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Company",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text("Company Name"),
                  SizedBox(height: 30),
                  Text(
                    "Department",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text("Department Name"),
                  SizedBox(height: 30),
                  Text(
                    "Position",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text("Position Title"),
                  SizedBox(height: 30),
                  Text(
                    "Date Hired",
                    style: TextStyle(color: primaryBlue),
                  ),
                  Text("MM/DD/YY"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
