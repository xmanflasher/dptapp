import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> dataPoints = [];
  Timer? _timer;
  int _timeCounter = 0;

  @override
  void initState() {
    super.initState();
    startReceivingData();
  }

  void startReceivingData() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        double newValue = getBluetoothData();
        dataPoints.add(FlSpot(_timeCounter.toDouble(), newValue));
        if (dataPoints.length > 20) {
          dataPoints.removeAt(0);
        }
        _timeCounter++;
      });
    });
  }

  double getBluetoothData() {
    return (5 + (10 * (DateTime.now().second % 10) / 10)); // 模擬藍牙數據
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                //colors: [Colors.blue],
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
