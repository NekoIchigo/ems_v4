import 'package:ems_v4/global/constants.dart';
// import 'package:ems_v4/global/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailsWidget extends StatefulWidget {
  const EmployeeDetailsWidget({super.key});

  @override
  State<EmployeeDetailsWidget> createState() => _EmployeeDetailsWidgetState();
}

class _EmployeeDetailsWidgetState extends State<EmployeeDetailsWidget>
    with SingleTickerProviderStateMixin {
  // final AuthService _authService = Get.find<AuthService>();
  bool _isExpanded = false;

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: gray),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Employment Details'),
              );
            },
            body: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              )),
              child: SizedBox(
                width: Get.width * .8,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company",
                        style: TextStyle(color: primaryBlue),
                      ),
                      Text("Company Name"),
                      SizedBox(height: 10),
                      Text(
                        "Department",
                        style: TextStyle(color: primaryBlue),
                      ),
                      Text("Department Name"),
                      SizedBox(height: 10),
                      Text(
                        "Position",
                        style: TextStyle(color: primaryBlue),
                      ),
                      Text("Position Title"),
                      SizedBox(height: 10),
                      Text(
                        "Date Hired",
                        style: TextStyle(color: primaryBlue),
                      ),
                      Text("MM/DD/YY"),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}
