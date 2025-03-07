import 'package:flutter/material.dart';
import 'package:dptapp/presentation/widgets/data_import.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('測試頁面')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataManagerWidget(),
      ),
    );
  }
}
