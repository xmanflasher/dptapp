import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/service/bluetooth_service.dart';

class BluetoothChartCubit extends Cubit<List<FlSpot>> {
  BluetoothChartCubit(this._dataSource) : super([]);

  DataSource _dataSource;
  int _timeCounter = 0;
  Duration _interval = const Duration(seconds: 1);

  void setDataSource(DataSource newSource) {
    _dataSource = newSource;
  }

  void setInterval(Duration duration) {
    _interval = duration;
  }

  Duration get interval => _interval;

  void addDataPoint() {
    double newValue = _dataSource.getData();
    final updated = [...state, FlSpot(_timeCounter.toDouble(), newValue)];
    if (updated.length > 20) updated.removeAt(0);
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
