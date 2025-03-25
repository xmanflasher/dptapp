import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dptapp/presentation/widgets/file_reader.dart';

part 'raw_data_event.dart';
part 'raw_data_state.dart';

class RawDataBloc extends Bloc<RawDataEvent, RawDataState> {
  RawDataBloc() : super(const RawDataState()) {
    on<ImportData>(_onImportData);
    on<SearchData>(_onSearchData);
    on<ToggleSelection>(_onToggleSelection);
    on<SelectAll>(_onSelectAll);
    on<DeleteSelected>(_onDeleteSelected);
    on<ClearDatabase>(_onClearDatabase);
  }

  Future<void> _onImportData(
      ImportData event, Emitter<RawDataState> emit) async {
    emit(
        state.copyWith(isActing: {...state.isActing, RawDataAction.importing}));

    try {
      // 使用 selectedFile 讀取檔案內容
      String fileContent = await rootBundle.loadString(event.selectedFile);
      List<List<dynamic>> data = state.selectedFile.endsWith('.csv')
          ? await CsvReader().readCsv(event.selectedFile)
          : await TxtReader().readTxt(event.selectedFile);

      // 將資料導入到 Hive
      var box = await Hive.openBox('importedDataBox');
      //await box.clear();
      await box.addAll(data);

      // 更新狀態
      List<dynamic> updatedResults = box.values.toList();
      emit(state.copyWith(
          searchResults: updatedResults,
          isActing: state.isActing..remove(RawDataAction.importing),));
    } catch (e) {
      emit(state.copyWith(
          isActing: state.isActing..remove(RawDataAction.importing)));
      print("Error importing data: $e");
    }
  }

  Future<void> _onSearchData(
      SearchData event, Emitter<RawDataState> emit) async {
    emit(
        state.copyWith(isActing: {...state.isActing, RawDataAction.searching}));

    var box = await Hive.openBox('importedDataBox');
    List<dynamic> results = box.values
        .where((item) => item.toString().contains(event.query))
        .toList();

    emit(state.copyWith(
        searchResults: results,
        isActing: state.isActing..remove(RawDataAction.searching)));
  }

  void _onToggleSelection(ToggleSelection event, Emitter<RawDataState> emit) {
    final newSelection = Set<int>.from(state.selectedItems);
    if (newSelection.contains(event.index)) {
      newSelection.remove(event.index);
    } else {
      newSelection.add(event.index);
    }
    emit(state.copyWith(selectedItems: newSelection));
  }

  void _onSelectAll(SelectAll event, Emitter<RawDataState> emit) {
    final newSelection = Set<int>.from(
      List.generate(state.searchResults.length, (index) => index),
    );
    emit(state.copyWith(selectedItems: newSelection));
  }

  Future<void> _onDeleteSelected(
      DeleteSelected event, Emitter<RawDataState> emit) async {
    if (state.selectedItems.isEmpty) return;

    emit(state.copyWith(isActing: {...state.isActing, RawDataAction.deleting}));

    var box = await Hive.openBox('importedDataBox');
    for (var index in state.selectedItems.toList().reversed) {
      box.deleteAt(index);
    }

    List<dynamic> updatedResults = box.values.toList();
    emit(state.copyWith(
        searchResults: updatedResults,
        selectedItems: {},
        isActing: state.isActing..remove(RawDataAction.deleting)));
  }

  Future<void> _onClearDatabase(
      ClearDatabase event, Emitter<RawDataState> emit) async {
    emit(state.copyWith(isActing: {...state.isActing, RawDataAction.clearing}));

    var box = await Hive.openBox('importedDataBox');
    await box.clear();

    emit(state.copyWith(
        searchResults: [],
        selectedItems: {},
        isActing: state.isActing..remove(RawDataAction.clearing)));
  }
}
