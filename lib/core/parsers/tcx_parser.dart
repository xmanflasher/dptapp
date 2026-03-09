import '../parsers/date_parser.dart';
import 'package:dptapp/features/activities/domain/lap.dart';
import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/activities/domain/detail.dart';

class TcxParser {
  static List<Lap> parseLaps(String tcxContent) {
    final List<Lap> laps = [];
    final lapRegex =
        RegExp(r'<Lap StartTime="(.*?)">(.*?)</Lap>', dotAll: true);
    final totalTimeRegex =
        RegExp(r'<TotalTimeSeconds>(.*?)</TotalTimeSeconds>');
    final distanceRegex = RegExp(r'<DistanceMeters>(.*?)</DistanceMeters>');
    final maxSpeedRegex = RegExp(r'<MaximumSpeed>(.*?)</MaximumSpeed>');
    final caloriesRegex = RegExp(r'<Calories>(.*?)</Calories>');
    final avgHrRegex = RegExp(
        r'<AverageHeartRateBpm>.*?<Value>(.*?)</Value>.*?</AverageHeartRateBpm>',
        dotAll: true);
    final maxHrRegex = RegExp(
        r'<MaximumHeartRateBpm>.*?<Value>(.*?)</Value>.*?</MaximumHeartRateBpm>',
        dotAll: true);
    final cadenceRegex = RegExp(r'<Cadence>(.*?)</Cadence>');

    final matches = lapRegex.allMatches(tcxContent);
    int index = 1;
    for (final match in matches) {
      final startTimeStr = match.group(1) ?? '';
      final lapData = match.group(2) ?? '';

      final totalTime = double.tryParse(
              totalTimeRegex.firstMatch(lapData)?.group(1) ?? '0') ??
          0.0;
      final distance =
          double.tryParse(distanceRegex.firstMatch(lapData)?.group(1) ?? '0') ??
              0.0;
      final maxSpeed =
          double.tryParse(maxSpeedRegex.firstMatch(lapData)?.group(1) ?? '0') ??
              0.0;
      final calories =
          int.tryParse(caloriesRegex.firstMatch(lapData)?.group(1) ?? '0') ?? 0;
      final avgHr =
          int.tryParse(avgHrRegex.firstMatch(lapData)?.group(1) ?? '0') ?? 0;
      final maxHr =
          int.tryParse(maxHrRegex.firstMatch(lapData)?.group(1) ?? '0') ?? 0;
      final cadence =
          int.tryParse(cadenceRegex.firstMatch(lapData)?.group(1) ?? '0') ?? 0;

      laps.add(Lap(
        index: index++,
        startTime: DateTime.tryParse(startTimeStr) ?? DateTime.now(),
        totalTimeSeconds: totalTime,
        distanceMeters: distance,
        maxSpeed: maxSpeed,
        calories: calories,
        averageHeartRate: avgHr,
        maxHeartRate: maxHr,
        averageCadence: cadence,
      ));
    }
    return laps;
  }

  static List<Detail> parseTrackpoints(String tcxContent, String activityId) {
    final List<Detail> details = [];
    final trackpointRegex =
        RegExp(r'<Trackpoint>(.*?)</Trackpoint>', dotAll: true);
    final timeRegex = RegExp(r'<Time>(.*?)</Time>');
    final distanceRegex = RegExp(r'<DistanceMeters>(.*?)</DistanceMeters>');
    final altitudeRegex = RegExp(r'<AltitudeMeters>(.*?)</AltitudeMeters>');
    final hrRegex = RegExp(
        r'<HeartRateBpm>.*?<Value>(.*?)</Value>.*?</HeartRateBpm>',
        dotAll: true);
    final speedRegex = RegExp(r'<ns3:Speed>(.*?)</ns3:Speed>');
    final cadenceRegex = RegExp(r'<Cadence>(.*?)</Cadence>');
    final latRegex = RegExp(r'<LatitudeDegrees>(.*?)</LatitudeDegrees>');
    final lonRegex = RegExp(r'<LongitudeDegrees>(.*?)</LongitudeDegrees>');

    final matches = trackpointRegex.allMatches(tcxContent);
    for (final match in matches) {
      final tpData = match.group(1) ?? '';

      final timeStr = timeRegex.firstMatch(tpData)?.group(1) ?? '';
      final distance =
          double.tryParse(distanceRegex.firstMatch(tpData)?.group(1) ?? '0') ??
              0.0;
      final altitude =
          double.tryParse(altitudeRegex.firstMatch(tpData)?.group(1) ?? '0') ??
              0.0;
      final hr =
          double.tryParse(hrRegex.firstMatch(tpData)?.group(1) ?? '0') ?? 0.0;
      final speed =
          double.tryParse(speedRegex.firstMatch(tpData)?.group(1) ?? '0') ??
              0.0;
      final cadence =
          double.tryParse(cadenceRegex.firstMatch(tpData)?.group(1) ?? '0') ??
              0.0;
      final lat =
          double.tryParse(latRegex.firstMatch(tpData)?.group(1) ?? '0') ?? 0.0;
      final lon =
          double.tryParse(lonRegex.firstMatch(tpData)?.group(1) ?? '0') ?? 0.0;

      details.add(Detail(
        id: activityId,
        time: DateTime.tryParse(timeStr) ?? DateTime.now(),
        distanceMeters3: distance,
        altitudeMeters: altitude,
        value: hr, // HR
        value2: cadence, // Cadence
        speed: speed,
        latitudeDegrees: lat,
        longitudeDegrees: lon,
      ));
    }
    return details;
  }
}
