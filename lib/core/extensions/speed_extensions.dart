// lib/extensions/speed_extensions.dart

extension SpeedExtensions on double {
  /// km/h -> 秒/500m
  double toPaceSecondsPer500m() {
    if (this <= 0 || isNaN || isInfinite) return double.nan;
    return 1800.0 / this;
  }

  /// 秒/500m -> km/h
  double toSpeedKmH() {
    if (this <= 0 || isNaN || isInfinite) return double.nan;
    return 1800.0 / this;
  }

  /// 格式化成 mm:ss.sss
  String toPaceString() {
    if (isNaN || isInfinite || this <= 0) return "-";
    int minutes = this ~/ 60;
    double seconds = this % 60;
    String secondsStr = seconds.toStringAsFixed(3);
    if (seconds < 10) secondsStr = '0$secondsStr';
    return "$minutes:$secondsStr";
  }
}
