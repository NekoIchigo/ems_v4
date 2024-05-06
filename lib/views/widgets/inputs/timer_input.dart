import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeTextField extends StatelessWidget {
  const TimeTextField({
    super.key,
    this.label,
    this.hint = "00:00",
  });

  final String? label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        _TimeInputFormatter(), // Custom input formatter for time
      ],
      textAlign: TextAlign.center,
      style: defaultStyle,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: hintStyle,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        isDense: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: gray,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: gray,
          ),
        ),
      ),
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Extract only digits from the input
    final int parsedValue =
        int.tryParse(newValue.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Extract hours and minutes
    int hours = (parsedValue ~/ 100).clamp(0, 24);
    int minutes = (parsedValue % 100).clamp(0, 60);

    // Format hours and minutes with leading zeros
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    // Construct formatted text
    String formattedText = '$formattedHours:$formattedMinutes';

    // Return formatted text with updated selection
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
