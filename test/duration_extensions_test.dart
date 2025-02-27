import 'package:flutter_test/flutter_test.dart';
import 'package:dptapp/core/extensions/duration_extensions.dart'; // 確保這裡的路徑符合你的專案結構

void main() {
  group('toDuration Tests', () {
    test('Parses hh:mm:ss format', () {
      expect("25:08:00".toDuration(), Duration(hours: 25, minutes: 8, seconds: 0));
    });

    test('Parses mm:ss format', () {
      expect("19:46".toDuration(), Duration(minutes: 19, seconds: 46));
    });

    test('Parses hh:mm format', () {
      expect("06:38".toDuration(), Duration(hours: 6, minutes: 38));
    });

    test('Parses single number as seconds', () {
      expect("17".toDuration(), Duration(seconds: 17));
    });

    test('Handles decimal input safely', () {
      expect("16.9".toDuration(), Duration(seconds: 16)); // 小數部分忽略
    });

    test('Handles invalid input gracefully', () {
      expect("--".toDuration(), Duration.zero);
      expect("".toDuration(), Duration.zero);
      expect("abc:def".toDuration(), Duration.zero);
    });
  });
}
