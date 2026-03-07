import 'package:dptapp/ini.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/activities/domain/activity_repository.dart';
import 'package:dptapp/core/services/file_reader.dart';
import 'package:dptapp/core/parsers/tcx_parser.dart';
import 'package:hive/hive.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  @override
  Future<List<Activity>> getAllActivities() async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch activities from CSV data source
          final List<List<dynamic>> data =
              await TxtReader().readTxt('test_data/Activities_untitle.txt');
              //await TxtReader().readTxt('D:/project/dptapp/assets/test_data/Activities.txt');
              //await CsvReader().readCsv('test_data/Activities_untitle.csv');
          return data.map((activity) => Activity.fromCsv(activity)).toList();
        case Env.dev:
        case Env.sit:
          // Fetch activities from Hive data source
          var box = await Hive.openBox('activitiesBox');
          return box.values.map((activity) => Activity.fromHive(activity)).toList();
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e, stackTrace) {
      print("Error loading activities: $e");
      print(stackTrace);
      return [Activity.defaultActivity];
    }
  }

  @override
  Future<Activity> getActivityById(String id) async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch activity by id from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('assets/data/activities.csv');
              await CsvReader().readCsv('assets/data/activities.csv');
          return data
              .map((activity) => Activity.fromCsv(activity))
              .firstWhere((activity) => activity.id == id);
        case Env.dev:
        case Env.sit:
          // Fetch activity by id from Hive data source
          var box = await Hive.openBox('activitiesBox');
          return Activity.fromHive(box.get(id));
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e) {
      return Activity.defaultActivity;
    }
  }

  @override
  Future<void> addActivity(Activity activity) async {
    // Implement your data adding logic here
  }

  @override
  Future<void> updateActivity(Activity activity) async {
    // Implement your data updating logic here
  }

  @override
  Future<void> deleteActivity(String id) async {
    // Implement your data deleting logic here
  }
}
