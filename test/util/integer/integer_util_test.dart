import 'package:flutter_social_media_v1/presentation/util/integer/integer_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntegerUtil', () {
    test('getPluralSuffix', () {

      testPluralSuffix('s', 0);
      testPluralSuffix('', 1);
      testPluralSuffix('s', 10);
    });
  });
}

void testPluralSuffix(String expected, int count) {
  final util = IntegerUtil();
  final result = util.getPluralSuffix(count: count);
  expect(result, expected);
}