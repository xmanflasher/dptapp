import 'package:flutter/material.dart';
import 'package:dptapp/presentation/widgets/raw_data_manager_widget.dart';
import 'package:dptapp/presentation/widgets/file_selector_widget.dart';
import '../widgets/navigation_drawer_widget.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(title: Text('測試頁面')),
      body: Container(
        color: Colors.grey[200], // 設置背景顏色
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white, // 設置內部容器背景顏色
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: FileSelectorWidget(
                onFileSelected: (selectedFile) {
                  setState(() {
                    _selectedFile = selectedFile; // 更新選擇的檔案
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white, // 設置內部容器背景顏色
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: RawDataManager(
                  selectedFile: _selectedFile, // 傳遞選擇的檔案
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
