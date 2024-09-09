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

  String getGreeting(hour) {
    if (hour >= 0 && hour < 12) {
      return 'Good morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  String time12to24(time) {
    return time.replaceAllMapped(
        RegExp(r'(\d+):(\d+) (AM|PM)'),
        (Match m) =>
            '${m[3] == 'AM' ? (m[1] == '12' ? '00' : m[1]) : int.parse(m[1]!) + 12}:${m[2]}');
  }

  String fromLaravelDateFormat(date) {
    DateTime dateTime = DateTime.parse(date);

    return DateFormat("MM/dd/yyyy").format(dateTime);
  }

  double timeToDecimal(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    double decimalHours = hours + (minutes / 60);
    return decimalHours;
  }

  String decimalToTime(double decimalHours) {
    int hours = decimalHours.toInt();
    int minutes = ((decimalHours - hours) * 60).toInt();

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }
}
