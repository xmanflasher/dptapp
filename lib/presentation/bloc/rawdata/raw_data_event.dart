part of 'raw_data_bloc.dart';

abstract class RawDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// 匯入資料
class ImportData extends RawDataEvent {
  final String selectedFile;
  ImportData(this.selectedFile);

  @override
  List<Object> get props => [selectedFile];
}

// 搜尋資料
class SearchData extends RawDataEvent {
  final String query;
  SearchData(this.query);

  @override
  List<Object> get props => [query];
}

// 選取/取消選取
class ToggleSelection extends RawDataEvent {
  final int index;
  ToggleSelection(this.index);

  @override
  List<Object> get props => [index];
}

// 選取全部
class SelectAll extends RawDataEvent {}

// 刪除選取的資料
class DeleteSelected extends RawDataEvent {}

// 清除資料庫
class ClearDatabase extends RawDataEvent {}
