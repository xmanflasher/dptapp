import 'package:equatable/equatable.dart';

enum CycleType { macro, meso, micro }

class TrainingCycle extends Equatable {
  final String id;
  final String name;
  final CycleType type;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const TrainingCycle({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }

  factory TrainingCycle.fromMap(Map<String, dynamic> map) {
    return TrainingCycle(
      id: map['id'],
      name: map['name'],
      type: CycleType.values[map['type']],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      description: map['description'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, type, startDate, endDate, description];
}
