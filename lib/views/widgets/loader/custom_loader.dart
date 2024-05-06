import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  final double? height, width, borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFc9c9c9),
      highlightColor: const Color(0xFFe6e6e6),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(borderRadius ?? 3),
        ),
      ),
    );
  }
}
