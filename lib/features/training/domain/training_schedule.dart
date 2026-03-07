import 'package:equatable/equatable.dart';

class TrainingSchedule extends Equatable {
  final String id;
  final String menuId;
  final DateTime date;
  final bool isCompleted;
  final String? activityId; // Reference to the recorded Activity

  const TrainingSchedule({
    required this.id,
    required this.menuId,
    required this.date,
    this.isCompleted = false,
    this.activityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'menuId': menuId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'activityId': activityId,
    };
  }

  factory TrainingSchedule.fromMap(Map<String, dynamic> map) {
    return TrainingSchedule(
      id: map['id'],
      menuId: map['menuId'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] ?? false,
      activityId: map['activityId'],
    );
  }

  @override
  List<Object?> get props => [id, menuId, date, isCompleted, activityId];
}
