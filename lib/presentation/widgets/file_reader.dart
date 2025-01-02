import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:io';

class CsvReader {
  Future<List<List<dynamic>>> readCsv(String path) async {
    final String csvData = await rootBundle.loadString(path);
    final List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(csvData);
    return csvTable;
  }
}

// Method to read CSV from a file
class TxtReader {
  Future<List<List<dynamic>>> readTxt(String filePath) async {
    try {
      // Read the entire file content
      final file = File(filePath);
      final content = await file.readAsString();

      // Split the content into lines
      final lines = content.split('\n');

      // Split each line into fields
      final List<List<dynamic>> data = lines.map((line) {
        return line.split(',').map((field) => field.trim()).toList();
      }).toList();

      return data;
    } catch (e) {
      throw Exception("Error reading txt file: $e");
    }
  }
}
/*
class TxtReader {
  Future<List<List<dynamic>>> readTxt(String filePath) async {
    try {
      final String fileData = await rootBundle.loadString(filePath);
      final List<List<dynamic>> fileTable = const CsvToListConverter().convert(fileData);
      return fileTable;
    } catch (e) {
      throw Exception("Error reading CSV file: $e");
    }
  }
}
*/
/*
class CsvReaderAsFile {
  Future<List<List<dynamic>>> readCsvFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final fileData = await file.readAsString();
      final List<List<dynamic>> fileTable = const CsvToListConverter().convert(fileData);
      return fileTable;
    } catch (e) {
      throw Exception("Error reading CSV file: $e");
    }
  }
}
*/