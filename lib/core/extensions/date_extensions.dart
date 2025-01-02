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