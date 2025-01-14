import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter/material.dart';

class AnnouncementDialog extends StatefulWidget {
  const AnnouncementDialog({super.key});

  @override
  State<AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<AnnouncementDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: Device.get().isTablet
          ? const EdgeInsets.symmetric(vertical: 20, horizontal: 100)
          : const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetAnimationDuration: const Duration(milliseconds: 100),
      child: Container(),
    );
  }
}
