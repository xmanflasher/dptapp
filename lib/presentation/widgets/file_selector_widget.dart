import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:dptapp/presentation/widgets/file_reader.dart';

class FileSelectorWidget extends StatefulWidget {
  final Function(String) onFileSelected;

  FileSelectorWidget({required this.onFileSelected});

  @override
  _FileSelectorWidgetState createState() => _FileSelectorWidgetState();
}

class _FileSelectorWidgetState extends State<FileSelectorWidget> {
  String? _selectedFile = "選取檔案"; // 預設選取「選取檔案」
  List<String> _files = ["選取檔案"]; // 加入預設選項
  final String assetPath = 'assets/test_data/';
  List<List<dynamic>> _rawData = [];

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
      _files = ["選取檔案", ...assetFiles]; // 確保「選取檔案」是第一個選項
      _selectedFile = "選取檔案";
    });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: _selectedFile,
          items: _files.map((String file) {
            return DropdownMenuItem<String>(
              value: file,
              child: Text(file.split('/').last),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null && newValue != "選取檔案") {
              setState(() {
                _selectedFile = newValue;
              });
              _loadRawData(newValue);
              widget.onFileSelected(newValue);
            } else {
              setState(() {
                _selectedFile = "選取檔案";
                _rawData = [];
              });
            }
          },
        ),
        Container(
          height: 200,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            children: _rawData.map((row) => Text(row.join(', '))).toList(),
          ),
        ),
      ],
    );
  }
}
