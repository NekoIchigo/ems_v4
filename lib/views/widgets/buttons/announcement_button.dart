import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnnouncementButton extends StatefulWidget {
  final void Function() onPressed;
  final DateTime date;
  final String title;
  const AnnouncementButton({
    super.key,
    required this.onPressed,
    required this.date,
    required this.title,
  });

  @override
  State<AnnouncementButton> createState() => _AnnouncementButtonState();
}

class _AnnouncementButtonState extends State<AnnouncementButton> {
  DateTimeUtils _dateTimeUtils = DateTimeUtils();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        side: const BorderSide(color: bgSky),
        backgroundColor: bgSky,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/svg/annoucement.svg', width: 25),
          Text(
            _dateTimeUtils.formatDate(dateTime: widget.date),
            style: const TextStyle(color: bgPrimaryBlue),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(color: darkGray),
            ),
          ),
        ],
      ),
    );
  }
}
