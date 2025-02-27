import 'package:flutter_test/flutter_test.dart';
import 'package:dptapp/core/extensions/duration_formatter.dart';
import 'package:intl/intl.dart';

void main() {
  group('DurationFormatter Tests', () {
    test('37.9 seconds format', () {
      Duration duration = Duration(seconds: 37, microseconds: 900000);
      expect(duration.toDisplayFormat(), '00:37.9');
    });

    test('1:22:33.4 format', () {
      Duration duration = Duration(hours: 1, minutes: 22, seconds: 33, microseconds: 400000);
      expect(duration.toDisplayFormat(), '1:22:33.4');
    });

    test('05:04 format', () {
      Duration duration = Duration(minutes: 5, seconds: 4, microseconds: 0);
      expect(duration.toDisplayFormat(), '05:04');
    });

    test('2:03:07.099 format', () {
      Duration duration = Duration(hours: 2, minutes: 3, seconds: 7, microseconds: 99000);
      expect(duration.toDisplayFormat(), '2:03:07.099');
    });

    test('15 seconds format', () {
      Duration duration = Duration(seconds: 15, microseconds: 0);
      expect(duration.toDisplayFormat(), '00:15');
    });

    test('37 seconds format', () {
      Duration duration = Duration(seconds: 37, microseconds: 0);
      expect(duration.toDisplayFormat(), '00:37');
    });

    test('37.12 seconds format', () {
      Duration duration = Duration(seconds: 37, microseconds: 120000);
      expect(duration.toDisplayFormat(), '00:37.12');
    });

    test('07.08 seconds format', () {
      Duration duration = Duration(seconds: 7, microseconds: 80000);
      expect(duration.toDisplayFormat(), '00:07.08');
    });

    test('10:05:08 format', () {
      Duration duration = Duration(hours: 10, minutes: 5, seconds: 8, microseconds: 0);
      expect(duration.toDisplayFormat(), '10:05:08');
    });

    test('Edge case: 0 seconds', () {
      Duration duration = Duration(seconds: 0);
      expect(duration.toDisplayFormat(), '00:00');
    });

    test('Edge case: 59.999 seconds', () {
      Duration duration = Duration(seconds: 59, microseconds: 999000);
      expect(duration.toDisplayFormat(), '00:59.999');
    });

    test('Edge case: 1 hour exactly', () {
      Duration duration = Duration(hours: 1);
      expect(duration.toDisplayFormat(), '1:00:00');
    });

    test('Edge case: 23:59:59', () {
      Duration duration = Duration(hours: 23, minutes: 59, seconds: 59);
      expect(duration.toDisplayFormat(), '23:59:59');
    });
  });
}

