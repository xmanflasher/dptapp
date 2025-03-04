import '../entities/activities.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getAllActivities();
  Future<Activity> getActivityById(String id);
  Future<void> addActivity(Activity activity);
  Future<void> updateActivity(Activity activity);
  Future<void> deleteActivity(String id);
}