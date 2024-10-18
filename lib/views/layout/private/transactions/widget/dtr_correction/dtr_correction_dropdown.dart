import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class DTRCorrectionDropdown extends StatefulWidget {
  final bool enable;
  final Function(dynamic) onSelected;
  const DTRCorrectionDropdown({
    super.key,
    this.enable = true,
    required this.onSelected,
  });

  @override
  State<DTRCorrectionDropdown> createState() => _DTRCorrectionDropdownState();
}

class _DTRCorrectionDropdownState extends State<DTRCorrectionDropdown> {
  List clockTypes = [
    {"name": "Clock In", "key": "clock_in"},
    {"name": "Clock Out", "key": "clock_out"},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DropdownMenu(
      width: size.width * .54,
      hintText: "-Select-",
      textStyle: defaultStyle,
      enabled: widget.enable,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        errorMaxLines: 1,
        filled: true,
        fillColor: widget.enable ? Colors.white : gray100,
        constraints: BoxConstraints.tight(
          const Size.fromHeight(40),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10,
        ),
        hintStyle: hintStyle,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: gray300),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: gray300),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: colorError),
        ),
      ),
      onSelected: widget.onSelected,
      menuStyle: const MenuStyle(
        surfaceTintColor: MaterialStatePropertyAll(Colors.white),
        backgroundColor: MaterialStatePropertyAll(Colors.white),
      ),
      dropdownMenuEntries: clockTypes.map<DropdownMenuEntry>((value) {
        return DropdownMenuEntry(
          value: value['key'],
          label: value['name'],
          labelWidget: Text(
            value['name'],
            style: const TextStyle(fontSize: 14),
          ),
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(primaryBlue),
          ),
        );
      }).toList(),
    );
  }
}
