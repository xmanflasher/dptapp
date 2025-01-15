
import 'package:intl/intl.dart';

extension StringDateParsing on String {
  DateTime flexibleParseDate() {
    try {
      // 格式範本：yyyy/MM/dd HH:mm
      final formatter = DateFormat('yyyy/MM/dd HH:mm');
      return formatter.parse(this);
    } catch (e) {
      try {
        // 格式範本：yyyy-MM-dd
        final formatter = DateFormat('yyyy-MM-dd');
        return formatter.parse(this);
      } catch (e) {
        try {
          // 新增格式範本：yyyy-MM-ddTHH:mm:ss.SSSZ
          final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
          return formatter.parseUTC(this).toLocal(); // 將 UTC 轉換為本地時間
        } catch (e) {
          throw FormatException("Invalid date format: $this");
        }
      }
    }
  }
}

/*
import 'package:intl/intl.dart';

extension StringDateParsing on String {
  DateTime flexibleParseDate() {
    try {
      final formatter = DateFormat('yyyy/MM/dd HH:mm');
      return formatter.parse(this);
    } catch (e) {
      try {
        final formatter = DateFormat('yyyy-MM-dd');
        return formatter.parse(this);
      } catch (e) {
        throw FormatException("Invalid date format: $this");
      }
    }
  }
}
*/