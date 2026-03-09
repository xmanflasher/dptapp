import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dptapp/core/services/bluetooth_service.dart';

class BluetoothChartCubit extends Cubit<List<FlSpot>> {
  BluetoothChartCubit(this._dataSource) : super([]) {
    _startPolling();
  }

  DataSource _dataSource;
  int _timeCounter = 0;
  Timer? _pollingTimer;
  Duration _interval = const Duration(seconds: 1);

  void setDataSource(DataSource newSource) {
    _dataSource = newSource;
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_interval, (_) => addDataPoint());
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  void setInterval(Duration duration) {
    _interval = duration;
    _startPolling();
  }

  Duration get interval => _interval;

  void addDataPoint() {
    double newValue = _dataSource.getData();
    final updated = List<FlSpot>.from(state);
    updated.add(FlSpot(_timeCounter.toDouble(), newValue));
    
    // Keep last 60 seconds (or current interval equivalent)
    if (updated.length > 60) {
      updated.removeAt(0);
    }
    
    _timeCounter++;
    emit(updated);
  }

  void reset() {
    _timeCounter = 0;
    emit([]);
  }

  double getLatestSpeed() {
    if (state.isNotEmpty) {
      return state.last.y;
    } else {
      return 0.0;
    }
  }
}
