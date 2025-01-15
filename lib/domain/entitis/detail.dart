import 'package:equatable/equatable.dart';
import 'package:dptapp/core/extensions/date_extensions.dart';
import 'package:dptapp/core/extensions/meter_extensions.dart';
import 'package:dptapp/core/extensions/speed_extensions.dart';

class Detail extends Equatable {
  final String sport;
  final String id;
  final DateTime startTime;
  final double totalTimeSeconds;
  final double distanceMeters;
  final double maximumSpeed;
  final int calories;
  final double value;
  final double value2;
  final String intensity;
  final String triggerMethod;
  final DateTime time;
  final double distanceMeters3;
  final double value4;
  final double? speed; // 可為 null
  final double? latitudeDegrees; // 可為 null
  final double? longitudeDegrees; // 可為 null
  final double? altitudeMeters; // 可為 null
  final double avgSpeed;
  final String name;
  final int unitId;
  final int productId;
  final int versionMajor;
  final int versionMinor;
  final int buildMajor;
  final int buildMinor;
  final String name5;
  final int versionMajor6;
  final int versionMinor7;
  final int buildMajor8;
  final int buildMinor9;
  final String langId;
  final String partNumber;

  Detail({
    this.sport = '',
    this.id = '',
    DateTime? startTime,
    this.totalTimeSeconds = 0.0,
    this.distanceMeters = 0.0,
    this.maximumSpeed = 0.0,
    this.calories = 0,
    this.value = 0.0,
    this.value2 = 0.0,
    this.intensity = '',
    this.triggerMethod = '',
    DateTime? time,
    this.distanceMeters3 = 0.0,
    this.value4 = 0.0,
    this.speed = 0.0,
    this.latitudeDegrees = 0.0,
    this.longitudeDegrees = 0.0,
    this.altitudeMeters = 0.0,
    this.avgSpeed = 0.0,
    this.name = '',
    this.unitId = 0,
    this.productId = 0,
    this.versionMajor = 0,
    this.versionMinor = 0,
    this.buildMajor = 0,
    this.buildMinor = 0,
    this.name5 = '',
    this.versionMajor6 = 0,
    this.versionMinor7 = 0,
    this.buildMajor8 = 0,
    this.buildMinor9 = 0,
    this.langId = '',
    this.partNumber = '',
  })  : startTime = startTime ?? DateTime.now(),
        time = time ?? DateTime.now();

// Factory method to create a Record from CSV data
  factory Detail.fromCsv(List<dynamic> csv) {
    try {
      return Detail(
        sport: csv[0] as String,
        id: csv[1] as String,
        startTime: ((csv[2] as String).flexibleParseDate()) ?? DateTime.now(),
        totalTimeSeconds: (csv[3] as num).toDouble(),
        distanceMeters: (csv[4] as num).toDouble(),
        maximumSpeed: (csv[5] as num).toDouble(),
        calories: csv[6] as int,
        value: (csv[7] as num).toDouble(),
        value2: (csv[8] as num).toDouble(),
        intensity: csv[9] as String,
        triggerMethod: csv[10] as String,
        time: ((csv[11] as String).flexibleParseDate()) ?? DateTime.now(),
        distanceMeters3: (csv[12] as num).toDouble(),
        value4: (csv[13] as num).toDouble(),
        //speed空值在garmin connect以0.0填充
        speed: parseNullableSpeed(csv[14])?.toDouble(),
        //latitudeDegrees: (csv[15] as num).toDouble(),
        latitudeDegrees: parseNullableNum(csv[15])?.toDouble(),
        longitudeDegrees: parseNullableNum(csv[16])?.toDouble(),
        altitudeMeters: parseNullableNum(csv[17])?.toDouble(),
        avgSpeed: (csv[18] as num).toDouble(),
        name: csv[19] as String,
        unitId: csv[20] as int,
        productId: csv[21] as int,
        versionMajor: csv[22] as int,
        versionMinor: csv[23] as int,
        buildMajor: csv[24] as int,
        buildMinor: csv[25] as int,
        name5: csv[26] as String,
        versionMajor6: csv[27] as int,
        versionMinor7: csv[28] as int,
        buildMajor8: csv[29] as int,
        buildMinor9: csv[30] as int,
        langId: csv[31] as String,
        partNumber: csv[32] as String,
      );
    } catch (e) {
      throw FormatException("Invalid CSV format: $csv, Error: $e");
    }
  }

  // Factory method to create a Record from Hive data
  factory Detail.fromHive(Map<String, dynamic> hive) {
    return Detail(
      sport: hive['sport'] as String,
      id: hive['id'] as String,
      startTime: DateTime.parse(hive['startTime'] as String),
      totalTimeSeconds: (hive['totalTimeSeconds'] as num).toDouble(),
      distanceMeters: (hive['distanceMeters'] as num).toDouble(),
      maximumSpeed: (hive['maximumSpeed'] as num).toDouble(),
      calories: hive['calories'] as int,
      value: (hive['value'] as num).toDouble(),
      value2: (hive['value2'] as num).toDouble(),
      intensity: hive['intensity'] as String,
      triggerMethod: hive['triggerMethod'] as String,
      time: DateTime.parse(hive['time'] as String),
      distanceMeters3: (hive['distanceMeters3'] as num).toDouble(),
      value4: (hive['value4'] as num).toDouble(),
      speed: (hive['speed'] as num).toDouble(),
      latitudeDegrees: (hive['latitudeDegrees'] as num).toDouble(),
      longitudeDegrees: (hive['longitudeDegrees'] as num).toDouble(),
      altitudeMeters: (hive['altitudeMeters'] as num).toDouble(),
      avgSpeed: (hive['avgSpeed'] as num).toDouble(),
      name: hive['name'] as String,
      unitId: hive['unitId'] as int,
      productId: hive['productId'] as int,
      versionMajor: hive['versionMajor'] as int,
      versionMinor: hive['versionMinor'] as int,
      buildMajor: hive['buildMajor'] as int,
      buildMinor: hive['buildMinor'] as int,
      name5: hive['name5'] as String,
      versionMajor6: hive['versionMajor6'] as int,
      versionMinor7: hive['versionMinor7'] as int,
      buildMajor8: hive['buildMajor8'] as int,
      buildMinor9: hive['buildMinor9'] as int,
      langId: hive['langId'] as String,
      partNumber: hive['partNumber'] as String,
    );
  }

  // Default record instance
  static final Detail defaultDetail = Detail(
    sport: 'default',
    id: 'default',
    startTime: DateTime.now(),
    totalTimeSeconds: 0.0,
    distanceMeters: 0.0,
    maximumSpeed: 0.0,
    calories: 0,
    value: 0.0,
    value2: 0.0,
    intensity: 'default',
    triggerMethod: 'default',
    time: DateTime.now(),
    distanceMeters3: 0.0,
    value4: 0.0,
    speed: 0.0,
    latitudeDegrees: 0.0,
    longitudeDegrees: 0.0,
    altitudeMeters: 0.0,
    avgSpeed: 0.0,
    name: 'default',
    unitId: 0,
    productId: 0,
    versionMajor: 0,
    versionMinor: 0,
    buildMajor: 0,
    buildMinor: 0,
    name5: 'default',
    versionMajor6: 0,
    versionMinor7: 0,
    buildMajor8: 0,
    buildMinor9: 0,
    langId: 'default',
    partNumber: 'default',
  );

  @override
  List<Object?> get props => [
        sport,
        id,
        startTime,
        totalTimeSeconds,
        distanceMeters,
        maximumSpeed,
        calories,
        value,
        value2,
        intensity,
        triggerMethod,
        time,
        distanceMeters3,
        value4,
        speed,
        latitudeDegrees,
        longitudeDegrees,
        altitudeMeters,
        avgSpeed,
        name,
        unitId,
        productId,
        versionMajor,
        versionMinor,
        buildMajor,
        buildMinor,
        name5,
        versionMajor6,
        versionMinor7,
        buildMajor8,
        buildMinor9,
        langId,
        partNumber
      ];
}
/*
  factory RecordDetail.fromJson(Map<String, dynamic> json) {
    return RecordDetail(
      sport: json['Sport'],
      id: json['ns1:Id'],
      startTime: DateTime.parse(json['StartTime']),
      totalTimeSeconds: (json['ns1:TotalTimeSeconds'] as num).toDouble(),
      distanceMeters: (json['ns1:DistanceMeters'] as num).toDouble(),
      maximumSpeed: (json['ns1:MaximumSpeed'] as num).toDouble(),
      calories: json['ns1:Calories'],
      value: (json['ns1:Value'] as num).toDouble(),
      value2: (json['ns1:Value2'] as num).toDouble(),
      intensity: json['ns1:Intensity'],
      triggerMethod: json['ns1:TriggerMethod'],
      time: DateTime.parse(json['ns1:Time']),
      distanceMeters3: (json['ns1:DistanceMeters3'] as num).toDouble(),
      value4: (json['ns1:Value4'] as num).toDouble(),
      speed: (json['ns2:Speed'] as num).toDouble(),
      latitudeDegrees: (json['ns1:LatitudeDegrees'] as num).toDouble(),
      longitudeDegrees: (json['ns1:LongitudeDegrees'] as num).toDouble(),
      altitudeMeters: (json['ns1:AltitudeMeters'] as num).toDouble(),
      avgSpeed: (json['ns2:AvgSpeed'] as num).toDouble(),
      name: json['ns1:Name'],
      unitId: json['ns1:UnitId'],
      productId: json['ns1:ProductID'],
      versionMajor: json['ns1:VersionMajor'],
      versionMinor: json['ns1:VersionMinor'],
      buildMajor: json['ns1:BuildMajor'],
      buildMinor: json['ns1:BuildMinor'],
      name5: json['ns1:Name5'],
      versionMajor6: json['ns1:VersionMajor6'],
      versionMinor7: json['ns1:VersionMinor7'],
      buildMajor8: json['ns1:BuildMajor8'],
      buildMinor9: json['ns1:BuildMinor9'],
      langId: json['ns1:LangID'],
      partNumber: json['ns1:PartNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Sport': sport,
      'ns1:Id': id,
      'StartTime': startTime.toIso8601String(),
      'ns1:TotalTimeSeconds': totalTimeSeconds,
      'ns1:DistanceMeters': distanceMeters,
      'ns1:MaximumSpeed': maximumSpeed,
      'ns1:Calories': calories,
      'ns1:Value': value,
      'ns1:Value2': value2,
      'ns1:Intensity': intensity,
      'ns1:TriggerMethod': triggerMethod,
      'ns1:Time': time.toIso8601String(),
      'ns1:DistanceMeters3': distanceMeters3,
      'ns1:Value4': value4,
      'ns2:Speed': speed,
      'ns1:LatitudeDegrees': latitudeDegrees,
      'ns1:LongitudeDegrees': longitudeDegrees,
      'ns1:AltitudeMeters': altitudeMeters,
      'ns2:AvgSpeed': avgSpeed,
      'ns1:Name': name,
      'ns1:UnitId': unitId,
      'ns1:ProductID': productId,
      'ns1:VersionMajor': versionMajor,
      'ns1:VersionMinor': versionMinor,
      'ns1:BuildMajor': buildMajor,
      'ns1:BuildMinor': buildMinor,
      'ns1:Name5': name5,
      'ns1:VersionMajor6': versionMajor6,
      'ns1:VersionMinor7': versionMinor7,
      'ns1:BuildMajor8': buildMajor8,
      'ns1:BuildMinor9': buildMinor9,
      'ns1:LangID': langId,
      'ns1:PartNumber': partNumber,
    };
  }
}
*/