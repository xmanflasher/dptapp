import 'package:hive/hive.dart';
import 'package:dptapp/features/training/domain/training_cycle.dart';
import 'package:dptapp/features/training/domain/training_menu.dart';
import 'package:dptapp/features/training/domain/training_schedule.dart';
import 'package:dptapp/features/training/domain/training_repository.dart';

class HiveTrainingRepository implements TrainingRepository {
  final Box _cycleBox = Hive.box('trainingCycles');
  final Box _menuBox = Hive.box('trainingMenus');
  final Box _scheduleBox = Hive.box('trainingSchedules');

  @override
  Future<List<TrainingCycle>> getAllCycles() async {
    return _cycleBox.values
        .map((e) => TrainingCycle.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveCycle(TrainingCycle cycle) async {
    await _cycleBox.put(cycle.id, cycle.toMap());
  }

  @override
  Future<void> deleteCycle(String id) async {
    await _cycleBox.delete(id);
  }

  @override
  Future<List<TrainingMenu>> getAllMenus() async {
    return _menuBox.values
        .map((e) => TrainingMenu.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveMenu(TrainingMenu menu) async {
    await _menuBox.put(menu.id, menu.toMap());
  }

  @override
  Future<void> deleteMenu(String id) async {
    await _menuBox.delete(id);
  }

  @override
  Future<List<TrainingSchedule>> getSchedulesInRange(DateTime start, DateTime end) async {
    return _scheduleBox.values
        .map((e) => TrainingSchedule.fromMap(Map<String, dynamic>.from(e)))
        .where((s) => s.date.isAfter(start.subtract(const Duration(days: 1))) && 
                      s.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  @override
  Future<void> saveSchedule(TrainingSchedule schedule) async {
    await _scheduleBox.put(schedule.id, schedule.toMap());
  }

  @override
  Future<void> deleteSchedule(String id) async {
    await _scheduleBox.delete(id);
  }

  @override
  Future<void> markScheduleCompleted(String scheduleId, String activityId) async {
    final scheduleData = _scheduleBox.get(scheduleId);
    if (scheduleData != null) {
      final schedule = TrainingSchedule.fromMap(Map<String, dynamic>.from(scheduleData));
      final updated = TrainingSchedule(
        id: schedule.id,
        menuId: schedule.menuId,
        date: schedule.date,
        isCompleted: true,
        activityId: activityId,
      );
      await saveSchedule(updated);
    }
  }
}
