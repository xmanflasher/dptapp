import 'package:flutter/material.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Page'),
      ),
      body: const Center(
        child: Text('This is the Record Page'),
      ),
    );
  }
}