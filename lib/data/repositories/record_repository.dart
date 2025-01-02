import 'package:dptapp/ini.dart'; // Import ini.dart
import '../../domain/entitis/records.dart';
import '../../domain/repositories/record_repository.dart';
import 'package:dptapp/presentation/widgets/file_reader.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RecordRepositoryImpl implements RecordRepository {
  @override
  Future<List<Record>> getAllRecords() async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch records from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('test_data/Activities_untitle.txt');
              await CsvReader().readCsv('test_data/Activities_untitle.csv');
          return data.map((record) => Record.fromCsv(record)).toList();
        case Env.dev:
        case Env.sit:
          // Fetch records from Hive data source
          var box = await Hive.openBox('recordsBox');
          return box.values.map((record) => Record.fromHive(record)).toList();
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e, stackTrace) {
      print("Error loading records: $e");
      print(stackTrace);
      return [Record.defaultRecord];
    }
  }

  @override
  Future<Record> getRecordById(String id) async {
    try {
      switch (AppIni.currentEnv) {
        case Env.mock:
          // Fetch record by id from CSV data source
          final List<List<dynamic>> data =
              //await TxtReader().readTxt('assets/data/records.csv');
              await CsvReader().readCsv('assets/data/records.csv');
          return data
              .map((record) => Record.fromCsv(record))
              .firstWhere((record) => record.id == id);
        case Env.dev:
        case Env.sit:
          // Fetch record by id from Hive data source
          var box = await Hive.openBox('recordsBox');
          return Record.fromHive(box.get(id));
        default:
          throw Exception("Unsupported environment");
      }
    } catch (e) {
      return Record.defaultRecord;
    }
  }

  @override
  Future<void> addRecord(Record record) async {
    // Implement your data adding logic here
  }

  @override
  Future<void> updateRecord(Record record) async {
    // Implement your data updating logic here
  }

  @override
  Future<void> deleteRecord(String id) async {
    // Implement your data deleting logic here
  }
}
