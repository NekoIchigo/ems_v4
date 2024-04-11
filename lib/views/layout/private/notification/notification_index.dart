import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';

class NotificationIndex extends StatefulWidget {
  const NotificationIndex({super.key});

  @override
  State<NotificationIndex> createState() => _NotificationIndexState();
}

class _NotificationIndexState extends State<NotificationIndex> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * .5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          NoResult(),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5.0),
          //   child: Text("This is an example notification!"),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5.0),
          //   child: Text(
          //       "This is an example notification! test tesat test test test"),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5.0),
          //   child: Text(
          //       "This is an example notification! asdasdsadsa dasdasds sadsdasd"),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5.0),
          //   child: Text("This is an example notification! dasdsadsd"),
          // ),
        ],
      ),
    );
  }
}
