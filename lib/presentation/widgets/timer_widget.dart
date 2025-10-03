import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth_chart_cubit.dart';
import '../../../domain/service/bluetooth_service.dart';
import 'line_chart_widget.dart';
import 'package:dptapp/core/parsers/duration_display_formatter.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  bool _isRunning = false;
  String _selectedSource = 'Bluetooth';
  double _intervalSeconds = 1.0;
  int _elapsedMicroseconds = 0;
  double _lastSpeed = 0;
  double _acceleration = 0;

  void _startTimer() {
    final cubit = context.read<BluetoothChartCubit>();
    cubit
        .setInterval(Duration(milliseconds: (_intervalSeconds * 1000).toInt()));
    _timer?.cancel();
    _timer = Timer.periodic(cubit.interval, (_) {
      cubit.addDataPoint();
      setState(() {
        _elapsedMicroseconds += cubit.interval.inMicroseconds;
        final newSpeed = cubit.getLatestSpeed();
        _acceleration = (_elapsedMicroseconds > 0)
            ? (newSpeed - _lastSpeed) / (_intervalSeconds)
            : 0;
        _lastSpeed = newSpeed;
      });
    });
    setState(() => _isRunning = true);
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _stopTimer();
    context.read<BluetoothChartCubit>().reset();
    setState(() {
      _elapsedMicroseconds = 0;
      _lastSpeed = 0;
      _acceleration = 0;
    });
  }

  void _switchSource(String? value) {
    if (value == null) return;
    final cubit = context.read<BluetoothChartCubit>();
    setState(() => _selectedSource = value);
    if (value == 'Bluetooth') {
      cubit.setDataSource(BluetoothService());
    } else {
      cubit.setDataSource(MockService());
    }
    if (_isRunning) {
      _startTimer();
    }
  }

  void _onIntervalChanged(double value) {
    setState(() => _intervalSeconds = value);
    if (_isRunning) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = Duration(microseconds: _elapsedMicroseconds);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: LineChartWidget(),
        ),
        Text("計時：${duration.toDisplayFormat()}",
            style: const TextStyle(fontSize: 16)),
        Text("速度：${_lastSpeed.toStringAsFixed(2)} km/h",
            style: const TextStyle(fontSize: 16)),
        Text("加速度：${_acceleration.toStringAsFixed(2)} km/h²",
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedSource,
          items: const [
            DropdownMenuItem(value: 'Bluetooth', child: Text('Bluetooth')),
            DropdownMenuItem(value: 'Mock', child: Text('Mock Data')),
          ],
          onChanged: _switchSource,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              const Text("更新間隔 (秒)"),
              Slider(
                value: _intervalSeconds,
                min: 0.1,
                max: 5.0,
                divisions: 49,
                label: _intervalSeconds.toStringAsFixed(1),
                onChanged: _onIntervalChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _startTimer,
              child: const Text("Start"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : null,
              child: const Text("Stop"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _resetTimer,
              child: const Text("Reset"),
            ),
          ],
        )
      ],
    );
  }
}
