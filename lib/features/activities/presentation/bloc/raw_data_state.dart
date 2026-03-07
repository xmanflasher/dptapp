part of 'raw_data_bloc.dart';

class RawDataState extends Equatable {
  final String selectedFile;
  final List<dynamic> searchResults;
  final Set<int> selectedItems;
  final Set<RawDataAction> isActing;
  final DataBox selectedBox;

  const RawDataState({
    this.selectedFile = '',
    this.searchResults = const [],
    this.selectedItems = const {},
    this.isActing = const {},
    this.selectedBox = DataBox.activities,
  });

  RawDataState copyWith({
    List<dynamic>? importData,
    List<dynamic>? searchResults,
    Set<int>? selectedItems,
    Set<RawDataAction>? isActing,
    DataBox? selectedBox,
  }) {
    return RawDataState(
      selectedFile: selectedFile,
      searchResults: searchResults ?? this.searchResults,
      selectedItems: selectedItems ?? this.selectedItems,
      isActing: isActing ?? this.isActing,
      selectedBox: selectedBox ?? this.selectedBox,
    );
  }

  @override
  List<Object> get props => [
        selectedFile,
        searchResults,
        selectedItems,
        isActing,
        selectedBox,
      ];
}
