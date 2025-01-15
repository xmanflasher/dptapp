import '../entitis/detail.dart';



abstract class DetailRepository {
  Future<List<Detail>> getAllDetail();
  Future<Detail> getDetailById(String id);
  Future<void> addDetail(Detail detail);
  Future<void> updateDetail(Detail detail);
  Future<void> deleteDetail(String id);
}