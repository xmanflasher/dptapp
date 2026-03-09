import 'package:equatable/equatable.dart';

enum TrainingType { interval, sprint, longDistance, recovery }

class TrainingMenu extends Equatable {
  final String id;
  final String name;
  final TrainingType type;
  final double? targetPower;
  final double? targetCadence;
  final Duration? expectedDuration;
  final double? expectedDistance;
  final String description;

  const TrainingMenu({
    required this.id,
    required this.name,
    required this.type,
    this.targetPower,
    this.targetCadence,
    this.expectedDuration,
    this.expectedDistance,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'targetPower': targetPower,
      'targetCadence': targetCadence,
      'expectedDuration': expectedDuration?.inSeconds,
      'expectedDistance': expectedDistance,
      'description': description,
    };
  }

  factory TrainingMenu.fromMap(Map<String, dynamic> map) {
    return TrainingMenu(
      id: map['id'],
      name: map['name'],
      type: TrainingType.values[map['type']],
      targetPower: map['targetPower'],
      targetCadence: map['targetCadence'],
      expectedDuration: map['expectedDuration'] != null
          ? Duration(seconds: map['expectedDuration'])
          : null,
      expectedDistance: map['expectedDistance'],
      description: map['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        targetPower,
        targetCadence,
        expectedDuration,
        expectedDistance,
        description
      ];
}
