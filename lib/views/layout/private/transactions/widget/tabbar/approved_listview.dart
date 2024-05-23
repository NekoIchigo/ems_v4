import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/models/transaction_item.dart';
import 'package:ems_v4/views/widgets/loader/custom_loader.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';

class ApprovedListview extends StatefulWidget {
  final List<TransactionItem> items;
  final bool isLoading;
  final Function(TransactionItem? item) onTap;

  const ApprovedListview({
    super.key,
    required this.items,
    required this.isLoading,
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
            itemCount: widget.isLoading ? 4 : widget.items.length,
            itemBuilder: (context, index) {
              late TransactionItem item;
              if (!widget.isLoading) {
                item = widget.items[index];
              }

              return widget.isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CustomLoader(
                        width: size.width,
                        height: 80,
                        borderRadius: 10,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                                  item.status,
                                  style: const TextStyle(
                                    color: orange,
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
