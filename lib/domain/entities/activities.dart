import 'package:equatable/equatable.dart';
import 'package:dptapp/core/parsers/date_parser.dart';
import 'package:dptapp/core/parsers/duration_formatter.dart';
import 'simulation_params.dart';
import 'lap.dart';

class Activity extends Equatable {
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

  // New Dragon Boat Specific Fields
  final double totalWork; // in Joules
  final double averagePower; // in Watts
  final double maxImpulse; // in N*s
  final SimulationParams? simulationParams;
  final List<Lap> lapsData;

  Activity({
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
    this.totalWork = 0.0,
    this.averagePower = 0.0,
    this.maxImpulse = 0.0,
    this.simulationParams,
    this.lapsData = const [],
  }) : date = date ?? DateTime.now();

  // Factory method to create a Activity from CSV data
  factory Activity.fromCsv(List<dynamic> csv) {
    try {
      return Activity(
        id: csv[0].toString(),
        activityType: csv[1] as String,
        date: ((csv[2] as String).flexibleParseDate()) ?? DateTime.now(),
        favorite: csv[3] == 'true',
        title: csv[4] as String,
        distance: double.tryParse(csv[5].toString()) ?? 0.0,
        caloriesBurned: int.tryParse(csv[6].toString()) ?? 0,
        time: (csv[7] as String).toDuration(),
        averageHeartRate: int.tryParse(csv[8].toString()) ?? 0,
        maxHeartRate: int.tryParse(csv[9].toString()) ?? 0,
        averageCadence: int.tryParse(csv[10].toString()) ?? 0,
        maxCadence: int.tryParse(csv[11].toString()) ?? 0,
        averagePace: (csv[12] as String).toDuration(),
        bestPace: (csv[13] as String).toDuration(),
        totalAscent: double.tryParse(csv[14].toString()) ?? 0.0,
        totalDescent: double.tryParse(csv[15].toString()) ?? 0.0,
        averageStrideLength: double.tryParse(csv[16].toString()) ?? 0.0,
        trainingStressScore: double.tryParse(csv[17].toString()) ?? 0.0,
        stressRelief: csv[18] == 'true',
        bestLapTime: (csv[19] as String).toDuration(),
        laps: int.tryParse(csv[20].toString()) ?? 0,
        movingTime: (csv[21] as String).toDuration(),
        totalTime: (csv[22] as String).toDuration(),
        minAltitude: double.tryParse(csv[23].toString()) ?? 0.0,
        maxAltitude: double.tryParse(csv[24].toString()) ?? 0.0,
        // New fields default to 0 for CSV imports (unless we add them to CSV later)
        totalWork: 0.0,
        averagePower: 0.0,
        maxImpulse: 0.0,
      );
    } catch (e) {
      throw FormatException("Invalid CSV format: $csv, Error: $e");
    }
  }

  // Factory method to create a Activity from Hive data
  factory Activity.fromHive(Map<String, dynamic> hive) {
    return Activity(
      id: hive['id'] as String,
      activityType: hive['activityType'] as String,
      date: DateTime.parse(hive['date'] as String),
      favorite: hive['favorite'] as bool,
      title: hive['title'] as String,
      distance: (hive['distance'] as num).toDouble(),
      caloriesBurned: hive['caloriesBurned'] as int,
      time: Duration(minutes: hive['time'] as int),
      averageHeartRate: hive['averageHeartRate'] as int,
      maxHeartRate: hive['maxHeartRate'] as int,
      averageCadence: hive['averageCadence'] as int,
      maxCadence: hive['maxCadence'] as int,
      averagePace: Duration(minutes: hive['averagePace'] as int),
      bestPace: Duration(minutes: hive['bestPace'] as int),
      totalAscent: (hive['totalAscent'] as num).toDouble(),
      totalDescent: (hive['totalDescent'] as num).toDouble(),
      averageStrideLength: (hive['averageStrideLength'] as num).toDouble(),
      trainingStressScore: (hive['trainingStressScore'] as num).toDouble(),
      stressRelief: hive['stressRelief'] as bool,
      bestLapTime: Duration(minutes: hive['bestLapTime'] as int),
      laps: hive['laps'] as int,
      movingTime: Duration(minutes: hive['movingTime'] as int),
      totalTime: Duration(minutes: hive['totalTime'] as int),
      minAltitude: (hive['minAltitude'] as num).toDouble(),
      maxAltitude: (hive['maxAltitude'] as num).toDouble(),
      totalWork: (hive['totalWork'] as num?)?.toDouble() ?? 0.0,
      averagePower: (hive['averagePower'] as num?)?.toDouble() ?? 0.0,
      maxImpulse: (hive['maxImpulse'] as num?)?.toDouble() ?? 0.0,
      simulationParams: hive['simulationParams'] != null 
          ? SimulationParams.fromMap(Map<String, dynamic>.from(hive['simulationParams']))
          : null,
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'activityType': activityType,
      'date': date.toIso8601String(),
      'favorite': favorite,
      'title': title,
      'distance': distance,
      'caloriesBurned': caloriesBurned,
      'time': time.inMinutes,
      'averageHeartRate': averageHeartRate,
      'maxHeartRate': maxHeartRate,
      'averageCadence': averageCadence,
      'maxCadence': maxCadence,
      'averagePace': averagePace.inMinutes,
      'bestPace': bestPace.inMinutes,
      'totalAscent': totalAscent,
      'totalDescent': totalDescent,
      'averageStrideLength': averageStrideLength,
      'trainingStressScore': trainingStressScore,
      'stressRelief': stressRelief,
      'bestLapTime': bestLapTime.inMinutes,
      'laps': laps,
      'movingTime': movingTime.inMinutes,
      'totalTime': totalTime.inMinutes,
      'minAltitude': minAltitude,
      'maxAltitude': maxAltitude,
      'totalWork': totalWork,
      'averagePower': averagePower,
      'maxImpulse': maxImpulse,
      'simulationParams': simulationParams?.toMap(),
    };
  }

  // Default Activity instance
  static final Activity defaultActivity = Activity(
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

  Activity copyWith({
    String? id,
    String? activityType,
    DateTime? date,
    bool? favorite,
    String? title,
    double? distance,
    int? caloriesBurned,
    Duration? time,
    int? averageHeartRate,
    int? maxHeartRate,
    int? averageCadence,
    int? maxCadence,
    Duration? averagePace,
    Duration? bestPace,
    double? totalAscent,
    double? totalDescent,
    double? averageStrideLength,
    double? trainingStressScore,
    bool? stressRelief,
    Duration? bestLapTime,
    int? laps,
    Duration? movingTime,
    Duration? totalTime,
    double? minAltitude,
    double? maxAltitude,
    double? totalWork,
    double? averagePower,
    double? maxImpulse,
    SimulationParams? simulationParams,
    List<Lap>? lapsData,
  }) {
    return Activity(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      date: date ?? this.date,
      favorite: favorite ?? this.favorite,
      title: title ?? this.title,
      distance: distance ?? this.distance,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      time: time ?? this.time,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      averageCadence: averageCadence ?? this.averageCadence,
      maxCadence: maxCadence ?? this.maxCadence,
      averagePace: averagePace ?? this.averagePace,
      bestPace: bestPace ?? this.bestPace,
      totalAscent: totalAscent ?? this.totalAscent,
      totalDescent: totalDescent ?? this.totalDescent,
      averageStrideLength: averageStrideLength ?? this.averageStrideLength,
      trainingStressScore: trainingStressScore ?? this.trainingStressScore,
      stressRelief: stressRelief ?? this.stressRelief,
      bestLapTime: bestLapTime ?? this.bestLapTime,
      laps: laps ?? this.laps,
      movingTime: movingTime ?? this.movingTime,
      totalTime: totalTime ?? this.totalTime,
      minAltitude: minAltitude ?? this.minAltitude,
      maxAltitude: maxAltitude ?? this.maxAltitude,
      totalWork: totalWork ?? this.totalWork,
      averagePower: averagePower ?? this.averagePower,
      maxImpulse: maxImpulse ?? this.maxImpulse,
      simulationParams: simulationParams ?? this.simulationParams,
      lapsData: lapsData ?? this.lapsData,
    );
  }

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
        totalWork,
        averagePower,
        maxImpulse,
        simulationParams,
        lapsData,
      ];
}
