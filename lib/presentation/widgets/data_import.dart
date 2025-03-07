import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dptapp/presentation/widgets/file_reader.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DataManagerWidget extends StatefulWidget {
  @override
  _DataManagerWidgetState createState() => _DataManagerWidgetState();
}

class _DataManagerWidgetState extends State<DataManagerWidget> {
  String? _selectedFile;
  List<String> _files = [];
  List<dynamic> _searchResults = [];
  List<List<dynamic>> _rawData = [];
  final String assetPath = 'assets/test_data/';
  bool _isSearching = false;
  bool _isImporting = false;
  int _currentPage = 0;
  static const int _itemsPerPage = 20;
  Set<int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadAssetFiles();
  }

  Future<void> _loadAssetFiles() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestJson);
    List<String> assetFiles = manifestMap.keys
        .where((String key) =>
            key.startsWith(assetPath) &&
            (key.endsWith('.csv') || key.endsWith('.txt')))
        .toList();

    setState(() {
      _files = assetFiles;
      _selectedFile = assetFiles.isNotEmpty ? assetFiles.first : null;
    });
    if (_selectedFile != null) {
      await _loadRawData(_selectedFile!);
    }
  }

  Future<void> _loadRawData(String filePath) async {
    String fileContent = await rootBundle.loadString(filePath);
    List<List<dynamic>> data = filePath.endsWith('.csv')
        ? await CsvReader().readCsv(filePath)
        : await TxtReader().readTxt(filePath);
    setState(() {
      _rawData = data;
    });
  }

  Future<void> _importData() async {
    if (_selectedFile != null) {
      setState(() => _isImporting = true);

      try {
        String fileContent = await rootBundle.loadString(_selectedFile!);
        List<List<dynamic>> rawData = _selectedFile!.endsWith('.csv')
            ? await CsvReader().readCsv(_selectedFile!)
            : await TxtReader().readTxt(_selectedFile!);

        List<dynamic> rows = rawData.where((row) => row.isNotEmpty).toList();
        var box = await Hive.openBox('importedDataBox');
        for (var row in rows) {
          box.add(row);
        }

        setState(() => _isImporting = false);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('導入完成'),
            content: Text('成功導入 ${rows.length} 筆資料'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('確定'),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() => _isImporting = false);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('導入失敗'),
            content: Text('錯誤訊息: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('確定'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _searchData(String query) async {
    setState(() => _isSearching = true);
    var box = await Hive.openBox('importedDataBox');
    setState(() {
      _searchResults =
          box.values.where((item) => item.toString().contains(query)).toList();
      _isSearching = false;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedItems = List.generate(
        _searchResults.length.clamp(0, _itemsPerPage),
        (index) => _currentPage * _itemsPerPage + index,
      ).toSet();
    });
  }

  void _deleteSelected() async {
    if (_selectedItems.isEmpty) {
      _showAlert("請勾選資料");
      return;
    }
    var box = await Hive.openBox('importedDataBox');
    for (var index in _selectedItems) {
      box.deleteAt(index);
    }
    setState(() {
      _searchResults.removeWhere((element) =>
          _selectedItems.contains(_searchResults.indexOf(element)));
      _selectedItems.clear();
    });
  }

  void _clearDatabase() async {
    var box = await Hive.openBox('importedDataBox');
    await box.clear();
    setState(() {
      _searchResults.clear();
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("提示"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("確定"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: _files.isNotEmpty ? _selectedFile : null, // 確保 value 不是 null
          hint: Text('選擇檔案'),
          items: _files.map((String file) {
            return DropdownMenuItem<String>(
              value: file,
              child: Text(file.split('/').last),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedFile = newValue;
              });
              _loadRawData(newValue);
            }
          },
        ),
        if (_rawData.isNotEmpty)
          Container(
            height: 200,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: ListView(
              children: _rawData.map((row) => Text(row.join(', '))).toList(),
            ),
          ),
        ElevatedButton(
          onPressed: _isImporting ? null : _importData,
          child: _isImporting ? CircularProgressIndicator() : Text('導入資料'),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: '搜尋',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchData(''),
                  ),
                ),
                onChanged: _searchData,
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(onPressed: _selectAll, child: Text("選取全部")),
            ElevatedButton(onPressed: _deleteSelected, child: Text("刪除")),
            ElevatedButton(onPressed: _clearDatabase, child: Text("清空資料庫")),
          ],
        ),
        if (_isSearching)
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (_isSearching) CircularProgressIndicator(),
        Expanded(
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              header: Text("搜尋結果"),
              columns: [
                //DataColumn(label: Text("選取")),
                DataColumn(label: Text("內容")),
              ],
              source:
                  _TableData(_searchResults, _selectedItems, _toggleSelection),
              rowsPerPage: _itemsPerPage,
            ),
          ),
        ),
      ],
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
      onSelectChanged: (selected) => onSelect(index),
      cells: [
        /*
        DataCell(Checkbox(
          value: selectedItems.contains(index),
          onChanged: (bool? value) => onSelect(index),
        )),
        */
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
