import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> webViewLauncher({
  required String url,
  String? errorMessage,
}) async {
  if (!await launchUrl(Uri.parse(url))) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return GemsDialog(
          title: "Oops",
          hasMessage: true,
          withCloseButton: true,
          hasCustomWidget: false,
          message: errorMessage ?? "Something went wrong!",
          type: "error",
          buttonNumber: 0,
        );
      },
    );
  }
}
