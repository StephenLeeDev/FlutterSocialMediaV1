import 'package:flutter_social_media_v1/presentation/util/date/date_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateUtil', () {
    test('getTimeAgo', () {
      final now = DateTime.now();

      testTimeAgo('1 second ago', now.subtract(const Duration(seconds: 1)).toString());
      testTimeAgo('30 seconds ago', now.subtract(const Duration(seconds: 30)).toString());
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
}

void testTimeAgo(String expected, String dateTimeString) {
  final dateUtil = DateUtil();
  final result = dateUtil.getTimeAgo(dateTimeString);
  expect(result, expected);
}