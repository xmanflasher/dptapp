import '../entitis/records.dart';



abstract class RecordRepository {
  Future<List<Record>> getAllRecords();
  Future<Record> getRecordById(String id);
  Future<void> addRecord(Record record);
  Future<void> updateRecord(Record record);
  Future<void> deleteRecord(String id);
}