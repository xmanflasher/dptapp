import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class CsvReader {
  Future<List<List<dynamic>>> readCsv(String path) async {
    final String csvData = await rootBundle.loadString(path);
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
    return csvTable;
  }
}