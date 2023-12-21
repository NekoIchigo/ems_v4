
import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatefulWidget {
  final int listLength;
  const ListShimmer({super.key, required this.listLength});

  @override
  State<ListShimmer> createState() => _ListShimmerState();
}

class _ListShimmerState extends State<ListShimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.listLength,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: lightGray),
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFc9c9c9),
            highlightColor: const Color(0xFFe6e6e6),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 50,
                  color: primaryBlue,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: Get.width * 0.5,
                      height: 10,
                      color: primaryBlue,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: Get.width * 0.7,
                      height: 10,
                      color: primaryBlue,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      width: Get.width * 0.6,
                      height: 10,
                      color: primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
