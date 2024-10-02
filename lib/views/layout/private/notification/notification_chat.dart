import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/layout/private/transactions/widget/tabbar/message_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationChat extends StatefulWidget {
  const NotificationChat({super.key});

  @override
  State<NotificationChat> createState() => _NotificationChatState();
}

class _NotificationChatState extends State<NotificationChat> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Messages",
                      style: TextStyle(
                        color: bgSecondaryBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  MessageTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
