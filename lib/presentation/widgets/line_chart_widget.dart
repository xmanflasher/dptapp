import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth_chart_cubit.dart';

class LineChartWidget extends StatelessWidget {
  final int displaySeconds; // 顯示的秒數，5~60，預設30
  const LineChartWidget({super.key, this.displaySeconds = 30});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothChartCubit, List<FlSpot>>(
      builder: (context, dataPoints) {
        final List<FlSpot> displayedData = dataPoints
            .where((point) =>
                point.x >= (dataPoints.lastOrNull?.x ?? 0) - displaySeconds)
            .toList();

        return AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorder:
                        const BorderSide(color: Color(0xff37434d)),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(2)} km/h',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 5,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (_) => const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}s',
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} km/h',
                            style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                minX: displayedData.isEmpty
                    ? 0
                    : displayedData.first.x,
                maxX: displayedData.isEmpty
                    ? displaySeconds.toDouble()
                    : displayedData.last.x,
                minY: 0,
                maxY: 20,
                lineBarsData: [
                  LineChartBarData(
                    spots: displayedData,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}