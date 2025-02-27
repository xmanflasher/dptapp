import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:dptapp/core/extensions/date_extensions.dart'; // 確保這裡的路徑符合你的專案結構

void main() {
  group('StringDateParsing - flexibleParseDate()', () {
    test('應該成功解析 yyyy/MM/dd HH:mm:ss 格式', () {
      String input = "2024/02/06 14:30:45";
      DateTime expected = DateFormat("yyyy/MM/dd HH:mm:ss").parse(input);
      DateTime result = input.flexibleParseDate();

      print('✅ 測試 yyyy/MM/dd HH:mm:ss: $input => $result');
      expect(result, expected);
    });

    test('應該成功解析 yyyy-MM-dd 格式', () {
      String input = "2024-02-06";
      DateTime expected = DateFormat("yyyy-MM-dd").parse(input);
      DateTime result = input.flexibleParseDate();

      print('✅ 測試 yyyy-MM-dd: $input => $result');
      expect(result, expected);
    });

    test('應該成功解析 UTC 格式 yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', () {
      String input = "2024-09-04T12:25:39.000Z";
      DateTime expected = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parseUTC(input).toLocal();
      DateTime result = input.flexibleParseDate();

      print('✅ 測試 UTC 格式: $input => $result');
      expect(result, expected);
    });

    test('無效格式應該拋出 FormatException', () {
      String input = "invalid-date-format";

      print('⚠️ 測試無效格式: $input 應該拋出 FormatException');
      expect(() => input.flexibleParseDate(), throwsFormatException);
    });
  });
}
//2024-09-04T12:25:39.000Z