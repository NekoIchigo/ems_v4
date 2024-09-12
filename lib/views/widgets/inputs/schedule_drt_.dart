import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:flutter/material.dart';

class ScheduleDTR extends StatelessWidget {
  const ScheduleDTR({
    super.key,
    required this.isLoading,
    this.scheduleName,
    this.dtrRange,
  });

  final bool isLoading;
  final String? scheduleName;
  final String? dtrRange;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 70,
              child: Text(
                "Schedule",
                style: defaultStyle,
              ),
            ),
            Expanded(
              child: isLoading
                  ? const CustomLoader(height: 30)
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: bgLightGray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        scheduleName ?? "--",
                        overflow: TextOverflow.ellipsis,
                        style: defaultStyle,
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
              child: Text("DTR", style: defaultStyle),
            ),
            Expanded(
              child: isLoading
                  ? const CustomLoader(height: 30)
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: gray100,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        dtrRange ?? "00:00 to 00:00",
                        overflow: TextOverflow.ellipsis,
                        style: defaultStyle,
                      ),
                    ),
            )
          ],
        ),
      ],
    );
  }
}
