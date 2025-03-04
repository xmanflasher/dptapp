import '../entities/detail.dart';



abstract class DetailRepository {
  Future<List<Detail>> getAllDetail();
  Future<List<Detail>> getDetailByDate(DateTime activityRecordDate);
  Future<Detail> getDetailById(String id);
  Future<void> addDetail(Detail detail);
  Future<void> updateDetail(Detail detail);
  Future<void> deleteDetail(String id);
}