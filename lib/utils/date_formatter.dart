import 'package:intl/intl.dart';

class DateFormatter {
  // Convert DateTime to "dd-MM-yyyy" format
  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Convert DateTime to "HH:mm:ss" format
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }
}
