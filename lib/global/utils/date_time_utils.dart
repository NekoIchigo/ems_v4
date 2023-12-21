import 'package:intl/intl.dart';

class DateTimeUtils {
  int calculateDateTimeDifference(
      String dateTime1, String dateTime2, String type) {
    final date1 = DateTime.parse(dateTime1);
    final date2 = DateTime.parse(dateTime2);

    final difference = date1.difference(date2);

    if (type == 'days') {
      return difference.inDays;
    } else {
      return difference.inMinutes;
    }
  }

  String formatTime({required String dateTime}) {
    if (dateTime != "") {
      DateTime timestamp = DateTime.parse(dateTime);
      return DateFormat("hh:mm a").format(timestamp);
    } else {
      return '?? : ??';
    }
  }

  String formatDate({required String dateTime}) {
    if (dateTime != "") {
      DateTime timestamp = DateTime.parse(dateTime);
      return DateFormat("MM/dd/yyyy").format(timestamp);
    } else {
      return '??/??/????';
    }
  }
}
