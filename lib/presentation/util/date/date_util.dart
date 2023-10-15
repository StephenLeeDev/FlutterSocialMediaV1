import 'package:intl/intl.dart';

class DateUtil {

  String getTimeAgo(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Less than 1 minute ago";
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays < 7) {
      if (difference.inDays == 1) {
        return '1 day ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } else {
      final weeks = difference.inDays ~/ 7;
      if (weeks == 1) {
        return '1 week ago';
      } else {
        return '$weeks weeks ago';
      }
    }
  }

  String getDateString(DateTime? date) {
    if (date == null) {
      return "";
    }

    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      /// If it's today
      // return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
      return "${date.hour%12}:${date.minute.toString()} ${date.hour >= 12 ? 'PM' : 'AM'}";
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      /// If it's yesterday
      return "Yesterday";
    } else if (date.year == now.year) {
      /// If it's this year
      return DateFormat.MMMMd().format(date);
    } else {
      /// If it's last year or earlier
      return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
    }
  }


}