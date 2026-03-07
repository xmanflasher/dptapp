import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dptapp/features/activities/data/activity_repository_impl.dart';
import 'package:dptapp/features/activities/data/detail_repository_impl.dart';
/*
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/activities/domain/activity_repository.dart';
import 'package:dptapp/features/activities/domain/detail_repository.dart';
import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/activities/domain/detail.dart';
*/
import 'package:dptapp/core/services/file_reader.dart';

class TransmitterWidget extends StatefulWidget {
  @override
  _TransmitterWidgetState createState() => _TransmitterWidgetState();
}

class _TransmitterWidgetState extends State<TransmitterWidget> {
  Timer? _timer;
  bool _isRunning = false;
  String _source = 'Hive';
  String _mode = 'Activities';

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _sendData();
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _sendData() async {
    final data = await _fetchData();
    print('Transmitting Data: $data');
  }

  Future<List<dynamic>> _fetchData() async {
    if (_mode == 'Activities') {
      return _source == 'Hive'
          ? await ActivityRepositoryImpl().getAllActivities()
          : await TxtReader().readTxt('test_data/Activities_untitle.txt');
    } else {
      return _source == 'Hive'
          ? await DetailRepositoryImpl().getAllDetail()
          : await CsvReader().readCsv('test_data/garmindata_800csv.csv');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _isRunning ? null : _startTimer, child: Text('發送')),
            SizedBox(width: 10),
            ElevatedButton(onPressed: _isRunning ? _pauseTimer : null, child: Text('暫停')),
            SizedBox(width: 10),
            ElevatedButton(onPressed: _stopTimer, child: Text('停止')),
          ],
        ),
        DropdownButton<String>(
          value: _source,
          items: ['Hive', 'Asset'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _source = newValue!;
            });
          },
        ),
        DropdownButton<String>(
          value: _mode,
          items: ['Activities', 'Detail'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _mode = newValue!;
            });
          },
        ),
      ],
    );
  }
}

