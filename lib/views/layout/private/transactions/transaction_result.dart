import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionResult extends StatelessWidget {
  const TransactionResult({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map<dynamic, dynamic> extraData =
        GoRouterState.of(context).extra! as Map<dynamic, dynamic>;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Icon(
              extraData["result"] ?? false ? Icons.check_circle : Icons.error,
              color:
                  extraData["result"] ?? false ? bgSecondaryBlue : colorError,
              size: 100,
            ),
            // Lottie.asset(
            //   extraData["result"] ?? false
            //       ? "assets/lottie/success-icon-6.json"
            //       : "assets/lottie/error-icon-2.json",
            //   repeat: false,
            //   width: 100,
            // ),
          ),
          const SizedBox(height: 50),
          Text(
            extraData["message"] ?? "Successfully sent a request.",
            style: defaultStyle,
          ),
          RoundedCustomButton(
            onPressed: () {
              context.go(extraData["path"] ?? "/transaction");
            },
            label: 'Close',
            size: Size(size.width * .8, 40),
            bgColor: bgPrimaryBlue,
            radius: 10,
          ),
        ],
      ),
    );
  }
}
