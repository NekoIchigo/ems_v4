import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemShimmer extends StatelessWidget {
  final bool? withLeading;
  const ItemShimmer({super.key, this.withLeading});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFc9c9c9),
      highlightColor: const Color(0xFFe6e6e6),
      child: Row(
        children: [
          Visibility(
            visible: withLeading ?? false,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: primaryBlue, borderRadius: BorderRadius.circular(5)),
            ),
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: size.width * 0.5,
                height: 10,
                decoration: BoxDecoration(
                    color: primaryBlue, borderRadius: BorderRadius.circular(5)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: size.width * 0.65,
                height: 10,
                decoration: BoxDecoration(
                    color: primaryBlue, borderRadius: BorderRadius.circular(5)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: size.width * 0.6,
                height: 10,
                decoration: BoxDecoration(
                    color: primaryBlue, borderRadius: BorderRadius.circular(5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
