import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/string_extension.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';

class ApprovedListview extends StatefulWidget {
  final List<TransactionItem> items;
  final Function(TransactionItem? item) onTap;

  const ApprovedListview({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  State<ApprovedListview> createState() => _ApprovedListviewState();
}

class _ApprovedListviewState extends State<ApprovedListview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.items.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              late TransactionItem item;

              item = widget.items[index];

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: gray,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    widget.onTap(item);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.status.capitalize(),
                            style: TextStyle(
                              color: item.status == "pending"
                                  ? orange
                                  : item.status == "approved"
                                      ? colorSuccess
                                      : colorError,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Text(
                        item.subtitle,
                        style: const TextStyle(color: gray),
                      ),
                      Text(
                        "Date Created: ${item.dateCreated}",
                        style: const TextStyle(color: gray),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const NoResult();
  }
}
