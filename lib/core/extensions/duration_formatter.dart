import 'package:intl/intl.dart';

extension DurationFormatter on Duration {
  String toDisplayFormat() {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);
    //int milliseconds = inMilliseconds.remainder(1000);
    int microseconds=inMicroseconds.remainder(1000000);
    // 格式化分鐘與秒數，確保補零（例如 00:37）
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    // 如果微秒數為 0，則不顯示
    if (microseconds == 0) {
      return hours > 0 ? "$hours:$minutesStr:$secondsStr" : "$minutesStr:$secondsStr";
    }

    // 去掉毫秒數後多餘的 0（例如 37.900000 → 37.9）
    String microsecondString = microseconds.toString().padLeft(6, '0');
    microsecondString = microsecondString.replaceFirst(RegExp(r'0+$'), ''); // 移除結尾的 0

    return hours > 0 
        ? "$hours:$minutesStr:$secondsStr.$microsecondString" 
        : "$minutesStr:$secondsStr.$microsecondString";
}
}