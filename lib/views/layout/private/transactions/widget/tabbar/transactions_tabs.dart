import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class TransactionsTabs extends StatelessWidget {
  final String title;
  final bool isActive;
  const TransactionsTabs({
    super.key,
    required this.title,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: isActive ? bgPrimaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.grey : Colors.white,
              offset: Offset(0, 5),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : bgPrimaryBlue,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
