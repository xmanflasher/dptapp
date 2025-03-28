import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/bloc.dart';
import 'package:dptapp/domain/enums.dart';

class RawDataManager extends StatelessWidget {
  final String? selectedFile;
  RawDataManager({this.selectedFile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RawDataBloc(),
      child: Column(
        children: [
          Row(
            children: [
              _buildBoxSelectorButton(context),
              SizedBox(width: 10),
              _buildFileActionButtons(context),
            ],
          ),
          _buildSearchBar(context),
          _buildActionButtons(context),
          SizedBox(height: 20),
          Expanded(child: _buildSearchResults(context)),
        ],
      ),
    );
  }

  Widget _buildBoxSelectorButton(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        if (state.isActing.isNotEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            DropdownButton<DataBox>(
              value: state.selectedBox,
              items: DataBox.values.map((DataBox box) {
                return DropdownMenuItem<DataBox>(
                  value: box,
                  child: Text(box.displayName),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  context.read<RawDataBloc>().add(DataBoxSelected(newValue));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFileActionButtons(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
        if (state.isActing.isNotEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => context
                  .read<RawDataBloc>()
                  .add(ImportData(selectedFile!, state.selectedBox)),
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
                    context.read<RawDataBloc>().add(SearchData('', state.selectedBox)),
              ),
            ),
            onChanged: (query) =>
                context.read<RawDataBloc>().add(SearchData(query, state.selectedBox)),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<RawDataBloc, RawDataState>(
      builder: (context, state) {
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
                  context.read<RawDataBloc>().add(DeleteSelected(state.selectedBox)),
              child: Text("刪除資料"),
            ),
            ElevatedButton(
              onPressed: () => context.read<RawDataBloc>().add(ClearDatabase(state.selectedBox)),
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
