import 'package:dptapp/ini.dart'; // Import ini.dart
import '../../domain/entities/detail.dart';
import '../../domain/repositories/detail_repository.dart';
import 'package:dptapp/presentation/widgets/file_reader.dart';
import 'package:hive/hive.dart';

class DetailRepositoryImpl implements DetailRepository {
  @override
  Future<List<Detail>> getAllDetail() async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch detail from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('test_data/Activities_untitle.txt');
              await CsvReader().readCsv('test_data/garmindata_800csv.csv');
          return data.map((detail) => Detail.fromCsv(detail)).toList();
        case Env.dev:
        case Env.sit:
          // Fetch detail from Hive data source
          var box = await Hive.openBox('detailBox');
          return box.values.map((detail) => Detail.fromHive(detail)).toList();
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e, stackTrace) {
      print("Error loading detail: $e");
      print(stackTrace);
      return [Detail.defaultDetail];
    }
  }

  @override
  Future<List<Detail>> getDetailByDate(DateTime activityRecordDate) async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch detail from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('test_data/Activities_untitle.txt');
              await CsvReader().readCsv('test_data/garmindata_800csv.csv');
          return data.map((detail) => Detail.fromCsvMap(detail,activityRecordDate)).toList();
        case Env.dev:
        case Env.sit:
          // Fetch detail from Hive data source
          var box = await Hive.openBox('detailBox');
          return box.values.map((detail) => Detail.fromHive(detail)).toList();
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e, stackTrace) {
      print("Error loading detail: $e");
      print(stackTrace);
      return [Detail.defaultDetail];
    }
  }
  
  @override
  Future<Detail> getDetailById(String id) async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch detail by id from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('assets/data/detail.csv');
              await CsvReader().readCsv('assets/data/garmindata_800csv.csv');
          return data
              .map((detail) => Detail.fromCsv(detail))
              .firstWhere((detail) => detail.id == id);
        case Env.dev:
        case Env.sit:
          // Fetch detail by id from Hive data source
          var box = await Hive.openBox('detailBox');
          return Detail.fromHive(box.get(id));
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e) {
      return Detail.defaultDetail;
    }
  }

  @override
  Future<void> addDetail(Detail detail) async {
    // Implement your data adding logic here
  }

  @override
  Future<void> updateDetail(Detail detail) async {
    // Implement your data updating logic here
  }

  @override
  Future<void> deleteDetail(String id) async {
    // Implement your data deleting logic here
  }
}
