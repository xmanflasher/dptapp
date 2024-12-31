import 'package:dptapp/domain/entitis/records.dart';

class RecordDTO{
const RecordDTO._();

static Record fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      activityType: map['activityType'],
      date: DateTime.parse(map['date']),
      favorite: map['favorite'],
      title: map['title'],
      distance: map['distance'],
      caloriesBurned: map['caloriesBurned'],
      time: Duration(minutes: map['time']),
      averageHeartRate: map['averageHeartRate'],
      maxHeartRate: map['maxHeartRate'],
      averageCadence: map['averageCadence'],
      maxCadence: map['maxCadence'],
      averagePace: Duration(minutes: map['averagePace']),
      bestPace: Duration(minutes: map['bestPace']),
      totalAscent: map['totalAscent'],
      totalDescent: map['totalDescent'],
      averageStrideLength: map['averageStrideLength'],
      trainingStressScore: map['trainingStressScore'],
      stressRelief: map['stressRelief'],
      bestLapTime: Duration(minutes: map['bestLapTime']),
      laps: map['laps'],
      movingTime: Duration(minutes: map['movingTime']),
      totalTime: Duration(minutes: map['totalTime']),
      minAltitude: map['minAltitude'],
      maxAltitude: map['maxAltitude'],
    );
  }

  // Convert RecordDto to Record
  static Map<String, dynamic> toMap(Record record) {
    return {
      'id': record.id,
      'activityType': record.activityType,
      'date': record.date.toIso8601String(),
      'favorite': record.favorite,
      'title': record.title,
      'distance': record.distance,
      'caloriesBurned': record.caloriesBurned,
      'time': record.time.inMinutes,
      'averageHeartRate': record.averageHeartRate,
      'maxHeartRate': record.maxHeartRate,
      'averageCadence': record.averageCadence,
      'maxCadence': record.maxCadence,
      'averagePace': record.averagePace.inMinutes,
      'bestPace': record.bestPace.inMinutes,
      'totalAscent': record.totalAscent,
      'totalDescent': record.totalDescent,
      'averageStrideLength': record.averageStrideLength,
      'trainingStressScore': record.trainingStressScore,
      'stressRelief': record.stressRelief,
      'bestLapTime': record.bestLapTime.inMinutes,
      'laps': record.laps,
      'movingTime': record.movingTime.inMinutes,
      'totalTime': record.totalTime.inMinutes,
      'minAltitude': record.minAltitude,
      'maxAltitude': record.maxAltitude,
    };
  }
}