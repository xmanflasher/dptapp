// duration_extensions.dart
extension DurationParsing on String {
  Duration toDuration() {
    try {
      if (this == "--" || trim().isEmpty) {
        return Duration.zero;
      }

      List<String> parts = split(':');

      if (parts.length == 3) {
        // hh:mm:ss
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        double seconds = double.parse(parts[2]);
        return Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds.truncate(),
          milliseconds: ((seconds - seconds.truncate()) * 1000).round(),
        );
      } else if (parts.length == 2) {
        if (contains('.')) {
          // mm:ss.sss (帶有小數點的秒數)
          int minutes = int.parse(parts[0]);
          double seconds = double.parse(parts[1]);
          return Duration(
            minutes: minutes,
            seconds: seconds.truncate(),
            milliseconds: ((seconds - seconds.truncate()) * 1000).round(),
          );
        } else {
          // hh:mm 或 mm:ss
          int first = int.parse(parts[0]);
          int second = int.parse(parts[1]);
          return first >= 60
              ? Duration(hours: first, minutes: second) // hh:mm
              : Duration(minutes: first, seconds: second); // mm:ss
        }
      } else if (parts.length == 1) {
        // 單獨數字，當作秒數
        double seconds = double.parse(parts[0]);
        return Duration(
          seconds: seconds.truncate(),
          milliseconds: ((seconds - seconds.truncate()) * 1000).round(),
        );
      }
    } catch (e) {
      return Duration.zero; // 遇到錯誤時返回 0
    }
    return Duration.zero;
  }
}

/*
extension DurationParsing on String {
  Duration toDuration() {
    if (this == "--" || trim().isEmpty) {
      return Duration.zero;
    }
    
    List<String> parts = split(":").reversed.toList(); // 反轉來處理不同長度的格式
    int hours = 0, minutes = 0, seconds = 0;
    
    if (parts.length > 0) seconds = int.tryParse(parts[0]) ?? 0;
    if (parts.length > 1) minutes = int.tryParse(parts[1]) ?? 0;
    if (parts.length > 2) hours = int.tryParse(parts[2]) ?? 0;
    
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
*/