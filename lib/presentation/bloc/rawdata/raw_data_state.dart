part of 'raw_data_bloc.dart';

enum RawDataAction { importing, searching, deleting, clearing }

class RawDataState extends Equatable {
  final String selectedFile;
  final List<dynamic> searchResults;
  final Set<int> selectedItems;
  // final bool isImporting;
  // final bool isSearching;
  // final bool isDeleting;
  // final bool isClearing;
  final Set<RawDataAction> isActing;

  const RawDataState({
    this.selectedFile = '',
    this.searchResults = const [],
    this.selectedItems = const {},
    // this.isImporting = false,
    // this.isSearching = false,
    // this.isDeleting = false,
    // this.isClearing = false,
    this.isActing = const {},
  });

  RawDataState copyWith({
    List<dynamic>? importData,
    List<dynamic>? searchResults,
    Set<int>? selectedItems,
    // bool? isImporting,
    // bool? isSearching,
    // bool? isDeleting,
    // bool? isClearing,
    Set<RawDataAction>? isActing,
  }) {
    return RawDataState(
      selectedFile: selectedFile,
      searchResults: searchResults ?? this.searchResults,
      selectedItems: selectedItems ?? this.selectedItems,
      // isImporting: isImporting ?? this.isImporting,
      // isSearching: isSearching ?? this.isSearching,
      // isDeleting: isDeleting ?? this.isDeleting,
      // isClearing: isClearing ?? this.isClearing,
      isActing: isActing ?? this.isActing,
    );
  }

  @override
  List<Object> get props => [
        selectedFile,
        searchResults,
        selectedItems,
        // isImporting,
        // isSearching,
        // isDeleting,
        // isClearing,
        isActing,
      ];
}
