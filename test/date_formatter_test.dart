import 'package:flutter_test/flutter_test.dart';
import 'package:dptapp/core/extensions/date_formatter.dart'; // 確保這裡的路徑符合你的專案結構
import 'package:intl/intl.dart';

void main() {
  group('DateTimeFormatting - toCustomFormat()', () {
    test('應該成功格式化 DateTime 為 yyyy-MM-dd HH:mm:ss', () {
      DateTime input = DateTime(2024, 2, 6, 14, 30, 45);
      String expected = "2024-02-06 14:30:45";
      String result = input.toCustomFormat();

      print('✅ 測試 DateTime 格式化: $input => $result');
      expect(result, expected);
    });

    test('應該正確格式化午夜時間 (00:00:00)', () {
      DateTime input = DateTime(2024, 2, 6, 0, 0, 0);
      String expected = "2024-02-06 00:00:00";
      String result = input.toCustomFormat();

      print('✅ 測試午夜時間: $input => $result');
      expect(result, expected);
    });

    test('應該正確格式化含毫秒的 DateTime（不顯示毫秒）', () {
      DateTime input = DateTime(2024, 2, 6, 14, 30, 45, 123);
      String expected = "2024-02-06 14:30:45";
      String result = input.toCustomFormat();

      print('✅ 測試含毫秒 DateTime: $input => $result');
      expect(result, expected);
    });

    test('應該正確格式化 UTC 時間', () {
      DateTime input = DateTime.utc(2024, 2, 6, 14, 30, 45);
      String expected = "2024-02-06 14:30:45";
      String result = input.toCustomFormat();

      print('✅ 測試 UTC DateTime: $input => $result');
      expect(result, expected);
    });

    test('應該成功解析並格式化 "2024-09-04T12:25:39.000Z"', () {
      String input = "2024-09-04T12:25:39.000Z";
      DateTime parsedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUTC(input).toLocal();
      String result = parsedDate.toCustomFormat();
      String expected = "2024-09-04 20:25:39"; // 轉換為當地時間 (假設 +8 小時時區)

      print('✅ 測試 UTC 時間格式化: $input => $result');
      expect(result, expected);
    });

    test('應該成功解析並格式化 "2024/9/4 20:25:39"', () {
      String input = "2024/9/4 20:25:39";
      DateTime parsedDate = DateFormat("yyyy/M/d HH:mm:ss").parse(input);
      String result = parsedDate.toCustomFormat();
      String expected = "2024-09-04 20:25:39";

      print('✅ 測試日期格式化: $input => $result');
      expect(result, expected);
    });
  });
}
