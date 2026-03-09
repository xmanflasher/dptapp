import 'package:dptapp/features/training/domain/training_cycle.dart';
import 'package:dptapp/features/training/domain/training_menu.dart';
import 'package:dptapp/features/training/domain/training_schedule.dart';

abstract class TrainingRepository {
  // Cycles
  Future<List<TrainingCycle>> getAllCycles();
  Future<void> saveCycle(TrainingCycle cycle);
  Future<void> deleteCycle(String id);

  // Menus
  Future<List<TrainingMenu>> getAllMenus();
  Future<void> saveMenu(TrainingMenu menu);
  Future<void> deleteMenu(String id);

  // Schedules
  Future<List<TrainingSchedule>> getSchedulesInRange(
      DateTime start, DateTime end);
  Future<void> saveSchedule(TrainingSchedule schedule);
  Future<void> deleteSchedule(String id);
  Future<void> markScheduleCompleted(String scheduleId, String activityId);
}
