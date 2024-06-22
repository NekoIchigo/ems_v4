import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/layout/private/time_entries/widgets/custom_date_bottomsheet.dart';
import 'package:flutter/material.dart';

class MonthFilterDropdown extends StatefulWidget {
  final Function(dynamic) onChanged;
  const MonthFilterDropdown({super.key, required this.onChanged});

  @override
  State<MonthFilterDropdown> createState() => _MonthFilterDropdownState();
}

class _MonthFilterDropdownState extends State<MonthFilterDropdown> {
  final List _list = [
    {'day': 1, 'label': 'Today'},
    {'day': 7, 'label': 'Last 7 days'},
    {'day': 30, 'label': 'Last 30 days'},
    {'day': 90, 'label': 'Last 3 months'},
    {'day': 0, 'label': 'Custom date range'},
  ];

  List? dates;

  late Object dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = _list[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Showing records for',
          style: TextStyle(color: gray, fontSize: 13),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              iconEnabledColor: Colors.white,
              value: dropdownValue,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(color: gray),
              onChanged: (value) async {
                // This is called when the user selects an item.
                if (value["day"] == 0) {
                  dates = await showModalBottomSheet(
                    context: navigatorKey.currentContext!,
                    builder: (context) =>
                        const CustomDateBottomsheet(type: 'range'),
                  );
                  value["dates"] = dates;
                }
                widget.onChanged(value);

                setState(() {
                  dropdownValue = value!;
                });
              },
              items: _list.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: Row(
                    children: [
                      const Icon(Icons.date_range_rounded, color: gray),
                      const SizedBox(width: 10),
                      Text(value['label']),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
