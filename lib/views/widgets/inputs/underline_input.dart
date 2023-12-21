import 'package:flutter/material.dart';

class UnderlineInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData icon;
  final TextEditingController textController;
  const UnderlineInput(
      {super.key,
      required this.label,
      required this.isPassword,
      required this.icon,
      required this.textController});

  @override
  State<UnderlineInput> createState() => _UnderlineInputState();
}

class _UnderlineInputState extends State<UnderlineInput> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
