import 'package:flutter_social_media_v1/presentation/util/date/date_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getTimeAgo', () {
    test('return time ago by DateTime', () {
      final now = DateTime.now();

      testTimeAgo('Less than 1 minute ago', now.subtract(const Duration(seconds: 1)).toString());
      testTimeAgo('Less than 1 minute ago', now.subtract(const Duration(seconds: 30)).toString());
      testTimeAgo('1 minute ago', now.subtract(const Duration(minutes: 1)).toString());
      testTimeAgo('30 minutes ago', now.subtract(const Duration(minutes: 30)).toString());
      testTimeAgo('1 hour ago', now.subtract(const Duration(hours: 1)).toString());
      testTimeAgo('12 hours ago', now.subtract(const Duration(hours: 12)).toString());
      testTimeAgo('1 day ago', now.subtract(const Duration(days: 1)).toString());
      testTimeAgo('5 days ago', now.subtract(const Duration(days: 5)).toString());
      testTimeAgo('1 week ago', now.subtract(const Duration(days: 7)).toString());
      testTimeAgo('30 weeks ago', now.subtract(const Duration(days: 210)).toString());
    });
  });

  group('getDateString', () {
    test('return date string by DateTime', () {
      final now = DateTime(2023, 10, 8, 10, 30);

      /// Today
      testDateString("10:30 AM", now);
      testDateString("10:30 PM", now.add(const Duration(hours: 12)));

      /// Yesterday
      DateTime yesterday = now.subtract(const Duration(days: 1));
      testDateString("Yesterday", yesterday);

      /// This year
      DateTime twoDaysAgo = now.subtract(const Duration(days: 2));
      DateTime lastMonth = now.subtract(const Duration(days: 14));
      testDateString("October 6", twoDaysAgo);
      testDateString("September 24", lastMonth);

      /// Last year
      testDateString("2022.10.08", now.subtract(const Duration(days: 365)));
    });
  });
}

void testTimeAgo(String expected, String dateTimeString) {
  final dateUtil = DateUtil();
  final result = dateUtil.getTimeAgo(dateTimeString);
  expect(result, expected);
}

void testDateString(String expected, DateTime dateTime) {
  final dateUtil = DateUtil();
  final result = dateUtil.getDateString(dateTime);
  expect(result, expected);
}