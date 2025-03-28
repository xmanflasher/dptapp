part of 'raw_data_bloc.dart';

abstract class RawDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// 選擇資料庫
class DataBoxSelected extends RawDataEvent {
  final DataBox selectedBox;
  DataBoxSelected(this.selectedBox);

  @override
  List<Object> get props => [selectedBox];
}

// 匯入資料
class ImportData extends RawDataEvent {
  final String selectedFile;
  final DataBox selectedBox;
  ImportData(this.selectedFile, this.selectedBox);

  @override
  List<Object> get props => [selectedFile, selectedBox];
}

// 搜尋資料
class SearchData extends RawDataEvent {
  final String query;
  final DataBox selectedBox;
  SearchData(this.query, this.selectedBox);

  @override
  List<Object> get props => [query, selectedBox];
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
class DeleteSelected extends RawDataEvent {
  final DataBox selectedBox;
  DeleteSelected(this.selectedBox);

  @override
  List<Object> get props => [selectedBox];
}

// 清除資料庫
class ClearDatabase extends RawDataEvent {
  final DataBox selectedBox;
  ClearDatabase(this.selectedBox);

  @override
  List<Object> get props => [selectedBox];
}
