import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';

class ScheduleDTR extends StatelessWidget {
  const ScheduleDTR({super.key, required this.isLoading});
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 70,
              child: Text("Schedule"),
            ),
            Expanded(
              child: isLoading
                  ? const CustomLoader(height: 30)
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "M-Sat 08:30 am - 05:30 pm (RD Sun)",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(
              width: 70,
              child: Text("DTR"),
            ),
            Expanded(
              child: isLoading
                  ? const CustomLoader(height: 30)
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "08:30 am to --:-- --",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            )
          ],
        ),
      ],
    );
  }
}
