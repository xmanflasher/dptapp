import 'package:equatable/equatable.dart';

class Record extends Equatable {
  final String id;
  final String activityType;
  final DateTime date;
  final bool favorite;
  final String title;
  final double distance;
  final int caloriesBurned;
  final Duration time;
  final int averageHeartRate;
  final int maxHeartRate;
  final int averageCadence;
  final int maxCadence;
  final Duration averagePace;
  final Duration bestPace;
  final double totalAscent;
  final double totalDescent;
  final double averageStrideLength;
  final double trainingStressScore;
  final bool stressRelief;
  final Duration bestLapTime;
  final int laps;
  final Duration movingTime;
  final Duration totalTime;
  final double minAltitude;
  final double maxAltitude;

  Record({
    this.id = '',
    this.activityType = '',
    DateTime? date,
    this.favorite = false,
    this.title = '',
    this.distance = 0.0,
    this.caloriesBurned = 0,
    this.time = Duration.zero,
    this.averageHeartRate = 0,
    this.maxHeartRate = 0,
    this.averageCadence = 0,
    this.maxCadence = 0,
    this.averagePace = Duration.zero,
    this.bestPace = Duration.zero,
    this.totalAscent = 0.0,
    this.totalDescent = 0.0,
    this.averageStrideLength = 0.0,
    this.trainingStressScore = 0.0,
    this.stressRelief = false,
    this.bestLapTime = Duration.zero,
    this.laps = 0,
    this.movingTime = Duration.zero,
    this.totalTime = Duration.zero,
    this.minAltitude = 0.0,
    this.maxAltitude = 0.0,
  }) : date = date ?? DateTime.now();

  // Factory method to create a Record from CSV data
  factory Record.fromCsv(List<dynamic> csv) {
  try {
    return Record(
      id: csv[0] as String,
      activityType: csv[1] as String,
      date: DateTime.parse(csv[2] as String),
      favorite: csv[3] == 'true',
      title: csv[4] as String,
      distance: double.tryParse(csv[5].toString()) ?? 0.0, // 避免解析錯誤
      caloriesBurned: int.tryParse(csv[6].toString()) ?? 0,
      time: Duration(minutes: int.tryParse(csv[7].toString()) ?? 0),
      averageHeartRate: int.tryParse(csv[8].toString()) ?? 0,
      maxHeartRate: int.tryParse(csv[9].toString()) ?? 0,
      averageCadence: int.tryParse(csv[10].toString()) ?? 0,
      maxCadence: int.tryParse(csv[11].toString()) ?? 0,
      averagePace: Duration(minutes: int.tryParse(csv[12].toString()) ?? 0),
      bestPace: Duration(minutes: int.tryParse(csv[13].toString()) ?? 0),
      totalAscent: double.tryParse(csv[14].toString()) ?? 0.0,
      totalDescent: double.tryParse(csv[15].toString()) ?? 0.0,
      averageStrideLength: double.tryParse(csv[16].toString()) ?? 0.0,
      trainingStressScore: double.tryParse(csv[17].toString()) ?? 0.0,
      stressRelief: csv[18] == 'true',
      bestLapTime: Duration(minutes: int.tryParse(csv[19].toString()) ?? 0),
      laps: int.tryParse(csv[20].toString()) ?? 0,
      movingTime: Duration(minutes: int.tryParse(csv[21].toString()) ?? 0),
      totalTime: Duration(minutes: int.tryParse(csv[22].toString()) ?? 0),
      minAltitude: double.tryParse(csv[23].toString()) ?? 0.0,
      maxAltitude: double.tryParse(csv[24].toString()) ?? 0.0,
    );
  } catch (e) {
    throw FormatException("Invalid CSV format: $csv, Error: $e");
  }
}


  // Factory method to create a Record from Hive data
  factory Record.fromHive(Map<String, dynamic> hive) {
    return Record(
      id: hive['id'] as String,
      activityType: hive['activityType'] as String,
      date: DateTime.parse(hive['date'] as String),
      favorite: hive['favorite'] as bool,
      title: hive['title'] as String,
      distance: hive['distance'] as double,
      caloriesBurned: hive['caloriesBurned'] as int,
      time: Duration(minutes: hive['time'] as int),
      averageHeartRate: hive['averageHeartRate'] as int,
      maxHeartRate: hive['maxHeartRate'] as int,
      averageCadence: hive['averageCadence'] as int,
      maxCadence: hive['maxCadence'] as int,
      averagePace: Duration(minutes: hive['averagePace'] as int),
      bestPace: Duration(minutes: hive['bestPace'] as int),
      totalAscent: hive['totalAscent'] as double,
      totalDescent: hive['totalDescent'] as double,
      averageStrideLength: hive['averageStrideLength'] as double,
      trainingStressScore: hive['trainingStressScore'] as double,
      stressRelief: hive['stressRelief'] as bool,
      bestLapTime: Duration(minutes: hive['bestLapTime'] as int),
      laps: hive['laps'] as int,
      movingTime: Duration(minutes: hive['movingTime'] as int),
      totalTime: Duration(minutes: hive['totalTime'] as int),
      minAltitude: hive['minAltitude'] as double,
      maxAltitude: hive['maxAltitude'] as double,
    );
  }

  // Default record instance
  static final Record defaultRecord = Record(
    id: 'default',
    activityType: 'Default Activity',
    date: DateTime.now(),
    favorite: false,
    title: 'Default Title',
    distance: 0.0,
    caloriesBurned: 0,
    time: Duration.zero,
    averageHeartRate: 0,
    maxHeartRate: 0,
    averageCadence: 0,
    maxCadence: 0,
    averagePace: Duration.zero,
    bestPace: Duration.zero,
    totalAscent: 0.0,
    totalDescent: 0.0,
    averageStrideLength: 0.0,
    trainingStressScore: 0.0,
    stressRelief: false,
    bestLapTime: Duration.zero,
    laps: 0,
    movingTime: Duration.zero,
    totalTime: Duration.zero,
    minAltitude: 0.0,
    maxAltitude: 0.0,
  );

  @override
  List<Object?> get props => [
        id,
        activityType,
        date,
        favorite,
        title,
        distance,
        caloriesBurned,
        time,
        averageHeartRate,
        maxHeartRate,
        averageCadence,
        maxCadence,
        averagePace,
        bestPace,
        totalAscent,
        totalDescent,
        averageStrideLength,
        trainingStressScore,
        stressRelief,
        bestLapTime,
        laps,
        movingTime,
        totalTime,
        minAltitude,
        maxAltitude,
      ];
}