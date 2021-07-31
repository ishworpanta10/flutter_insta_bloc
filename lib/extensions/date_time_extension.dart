import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeAgo;

extension DateTimeExtension on DateTime {
  String timeAgoExt() {
    final currentDate = DateTime.now();
    if (currentDate.difference(this).inDays > 1) {
      return DateFormat.yMMMd().format(this);
    }
    return timeAgo.format(this);
  }
}
