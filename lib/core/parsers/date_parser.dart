import 'package:intl/intl.dart';

extension StringDateParsing on String {
  DateTime flexibleParseDate() {
    try {
      // 新增格式範本：yyyy-MM-ddTHH:mm:ss.SSSZ
      //final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
      return formatter.parseUTC(this).toLocal(); // 將 UTC 轉換為本地時間
    } catch (e) {
      try {
        // 格式範本：yyyy/MM/dd HH:mm
        //final formatter = DateFormat('yyyy/MM/dd HH:mm');
        final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
        return formatter.parse(this);
      } catch (e) {
        throw FormatException("Invalid date format: $this");
      }
    }
  }
}
//2024-09-04T12:25:39.000Z
/*
extension StringDateParsing on String {
  DateTime flexibleParseDate() {
    try {
      // 格式範本：yyyy/MM/dd HH:mm
      //final formatter = DateFormat('yyyy/MM/dd HH:mm');
      final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
      return formatter.parse(this);
    } catch (e) {
      try {
        // 格式範本：yyyy-MM-dd
        final formatter = DateFormat('yyyy-MM-dd');
        return formatter.parse(this);
      } catch (e) {
        try {
          // 新增格式範本：yyyy-MM-ddTHH:mm:ss.SSSZ
          //final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
          final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
          return formatter.parseUTC(this).toLocal(); // 將 UTC 轉換為本地時間
        } catch (e) {
          throw FormatException("Invalid date format: $this");
        }
      }
    }
  }
}
*/
