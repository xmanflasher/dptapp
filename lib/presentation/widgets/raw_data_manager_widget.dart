import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/bloc.dart';

class RawDataManager extends StatelessWidget {
  final String? selectedFile;

  RawDataManager({this.selectedFile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RawDataBloc(),
      child: Column(
        children: [
          _buildFileActionButtons(context),
          _buildSearchBar(context),
          _buildActionButtons(context),
          SizedBox(height: 20),
          Expanded(child: _buildSearchResults(context)),
        ],
      ),
    );
  }

  Widget _buildFileActionButtons(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        //_importData
        if (state.isActing.isNotEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            ElevatedButton(
              onPressed: () =>
                  context.read<RawDataBloc>().add(ImportData(selectedFile!)),
              child: Text("導入資料"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: '搜尋',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    context.read<RawDataBloc>().add(SearchData('')),
              ),
            ),
            onChanged: (query) =>
                context.read<RawDataBloc>().add(SearchData(query)),
          ),
        );
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: TextField(
    //     decoration: InputDecoration(
    //       labelText: '搜尋',
    //       suffixIcon: IconButton(
    //         icon: Icon(Icons.search),
    //         onPressed: () => context.read<RawDataBloc>().add(SearchData('')),
    //       ),
    //     ),
    //     onChanged: (query) =>
    //         context.read<RawDataBloc>().add(SearchData(query)),
    //   ),
    // );
  }

/*
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => context.read<RawDataBloc>().add(SelectAll()),
          child: Text("選取全部"),
        ),
        ElevatedButton(
          onPressed: () => context.read<RawDataBloc>().add(DeleteSelected()),
          child: Text("刪除資料"),
        ),
        ElevatedButton(
          onPressed: () => context.read<RawDataBloc>().add(ClearDatabase()),
          child: Text("清除資料庫"),
        ),
      ],
    );
  }
  */
  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        //_importData
        if (state.isActing.isNotEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => context.read<RawDataBloc>().add(SelectAll()),
              child: Text("選取全部"),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.read<RawDataBloc>().add(DeleteSelected()),
              child: Text("刪除資料"),
            ),
            ElevatedButton(
              onPressed: () => context.read<RawDataBloc>().add(ClearDatabase()),
              child: Text("清除資料庫"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        if (state.isActing.isNotEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.searchResults.isEmpty) {
          return Center(child: Text("無搜尋結果"));
        }

        return SingleChildScrollView(
          child: PaginatedDataTable(
            header: Text("搜尋結果"),
            columns: const [
              DataColumn(label: Text("Index")),
              DataColumn(label: Text("內容")),
            ],
            source:
                _TableData(state.searchResults, state.selectedItems, (index) {
              context.read<RawDataBloc>().add(ToggleSelection(index));
            }),
            rowsPerPage: state.searchResults.length < 20
                ? state.searchResults.length
                : 20,
          ),
        );
      },
    );
  }
}

class _TableData extends DataTableSource {
  final List<dynamic> data;
  final Set<int> selectedItems;
  final Function(int) onSelect;

  _TableData(this.data, this.selectedItems, this.onSelect);

  @override
  DataRow getRow(int index) {
    return DataRow(
      selected: selectedItems.contains(index),
      onSelectChanged: (_) => onSelect(index),
      cells: [
        DataCell(Text(index.toString())),
        DataCell(Text(data[index].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => selectedItems.length;
}
