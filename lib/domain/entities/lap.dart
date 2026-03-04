import 'package:equatable/equatable.dart';

class Lap extends Equatable {
  final int index;
  final DateTime startTime;
  final double totalTimeSeconds;
  final double distanceMeters;
  final double maxSpeed;
  final int calories;
  final int averageHeartRate;
  final int maxHeartRate;
  final int averageCadence;
  final String intensity;

  const Lap({
    required this.index,
    required this.startTime,
    required this.totalTimeSeconds,
    required this.distanceMeters,
    required this.maxSpeed,
    required this.calories,
    required this.averageHeartRate,
    required this.maxHeartRate,
    required this.averageCadence,
    this.intensity = 'Active',
  });

  @override
  List<Object?> get props => [
        index,
        startTime,
        totalTimeSeconds,
        distanceMeters,
        maxSpeed,
        calories,
        averageHeartRate,
        maxHeartRate,
        averageCadence,
        intensity,
      ];
}
