import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/loader/item_shimmer.dart';
import 'package:flutter/material.dart';

class ListShimmer extends StatelessWidget {
  final int listLength;
  final bool? withLeading;
  const ListShimmer({
    super.key,
    required this.listLength,
    this.withLeading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: listLength,
      itemBuilder: (context, index) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: lightGray),
            ),
          ),
          child: ItemShimmer(withLeading: withLeading),
        );
      },
    );
  }
}
