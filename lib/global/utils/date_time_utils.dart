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

  String formatTime({DateTime? dateTime}) {
    if (dateTime != null) {
      return DateFormat("hh:mm a").format(dateTime);
    } else {
      return '?? : ??';
    }
  }

  String formatDate({DateTime? dateTime}) {
    if (dateTime != null) {
      return DateFormat("MM/dd/yyyy").format(dateTime);
    } else {
      return '??/??/????';
    }
  }
}
