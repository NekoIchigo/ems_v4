import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/transaction_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 25),
        const Text(
          "Transactions",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: size.height * .6,
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            crossAxisCount: 2,
            childAspectRatio: 1.25,
            children: [
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "Time Records",
                child: const Center(
                  child: Icon(
                    Icons.calendar_month,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "DTR Corrections",
                child: const Center(
                  child: Icon(
                    Icons.edit_calendar_rounded,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "Leave",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/leave.svg",
                    height: 45,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "Overtime",
                child: const Center(
                  child: Icon(
                    Icons.more_time,
                    size: 50,
                    color: bgPrimaryBlue,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "Change Schedule",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/change_schedule.svg",
                    height: 50,
                  ),
                ),
              ),
              TransactionMenuButton(
                onPressed: () {
                  context.go('');
                },
                title: "Change Restday",
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/change_restday.svg",
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
