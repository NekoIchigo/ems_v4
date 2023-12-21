import 'package:flutter/material.dart';

class GetDialog extends StatelessWidget {
  final String type;
  final String title;
  final String? message;

  const GetDialog({
    super.key,
    required this.type,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return const Dialog();
  }
}
