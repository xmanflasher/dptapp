import 'package:fl_chart/fl_chart.dart';
import 'package:dptapp/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/navigation_drawer_widget.dart';
import '../../data/repositories/detail_repository.dart';
import '../../domain/entities/detail.dart';
import '../../domain/entities/activities.dart';
import '../widgets/DataDisplayCard.dart';
import 'package:dptapp/core/parsers/duration_display_formatter.dart';
import 'package:dptapp/core/extensions/speed_extensions.dart';

import '../../core/parsers/physics_engine.dart';
import '../../domain/entities/simulation_params.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/export_service.dart';

class DetailPage extends StatefulWidget {
  final Activity activity;
  const DetailPage({Key? key, required this.activity}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  bool _showSpeed = true;
  bool _showHR = false;
  bool _showCadence = false;
  late TabController _tabController;
  late Future<List<Detail>> _detailFuture;
  List<Detail> details = [];
  late SimulationParams _currentParams;
  double _calculatedWork = 0;
  double _calculatedPower = 0;
  double _calculatedImpulse = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _detailFuture = DetailRepositoryImpl().getDetailByDate(widget.activity.date);
    
    _currentParams = widget.activity.simulationParams ?? const SimulationParams();
    if (_currentParams.crewDistribution.isEmpty) {
      _currentParams = _currentParams.copyWith(crewDistribution: List.filled(20, 0.0));
    }
    _recalculateMetrics();
  }

  void _recalculateMetrics() {
    final summary = PhysicsEngine.calculateSummary(
      totalDistance: widget.activity.distance,
      totalTime: widget.activity.time,
      avgCadence: widget.activity.averageCadence.toDouble(),
      params: _currentParams,
    );
    setState(() {
      _calculatedWork = summary['totalWork'] ?? 0;
      _calculatedPower = summary['averagePower'] ?? 0;
      _calculatedImpulse = summary['avgImpulse'] ?? 0;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activities),
        actions: [
          if (widget.activity.simulationParams != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(child: Text(l10n.specializedMode, style: const TextStyle(fontSize: 10, color: Colors.greenAccent))),
            ),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
      body: FutureBuilder<List<Detail>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No details found.'));
          } else {
            details = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LineChart(mainData()),
                        ),
                      ),
                        Wrap(
                          spacing: 8,
                          children: [
                            FilterChip(
                              label: const Text("Speed"),
                              selected: _showSpeed,
                              onSelected: (v) => setState(() => _showSpeed = v),
                            ),
                            FilterChip(
                              label: const Text("HR"),
                              selected: _showHR,
                              onSelected: (v) => setState(() => _showHR = v),
                            ),
                            FilterChip(
                              label: const Text("Cadence"),
                              selected: _showCadence,
                              onSelected: (v) => setState(() => _showCadence = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: AppColors.contentColorCyan,
                          tabs: [
                            Tab(text: l10n.summary), 
                            Tab(text: l10n.lapsData),
                            Tab(text: l10n.routeMap),
                            Tab(text: l10n.deepPhysicsAnalysis),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: _buildStatGrid(l10n),
                                  ),
                                ),
                                _buildSplitsList(l10n),
                                _buildMapView(),
                                _buildPhysicsTab(l10n),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
    );
  }
  // Playback overlay has been removed for production usage

  Widget _buildMapView() {
    final List<LatLng> points = details
        .where((d) => d.latitudeDegrees != null && d.longitudeDegrees != null && d.latitudeDegrees != 0 && d.longitudeDegrees != 0)
        .map((d) => LatLng(d.latitudeDegrees!, d.longitudeDegrees!))
        .toList();

    if (points.isEmpty) {
      return const Center(child: Text("No GPS data available for this activity."));
    }

    // Determine bounds for initial zoom
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    final center = LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2);

    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 14.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.dptapp.app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: points,
              color: AppColors.contentColorBlue,
              strokeWidth: 4,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: points.first,
              width: 20,
              height: 20,
              builder: (ctx) => const Icon(Icons.play_circle_fill, color: Colors.green, size: 20),
            ),
            Marker(
              point: points.last,
              width: 20,
              height: 20,
              builder: (ctx) => const Icon(Icons.stop_circle, color: Colors.red, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhysicsTab(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Environment (Interactive)", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    onPressed: _exportReport,
                    tooltip: "Export CSV",
                  ),
                  TextButton(
                    onPressed: () => setState(() {
                      _currentParams = widget.activity.simulationParams ?? const SimulationParams();
                      _recalculateMetrics();
                    }),
                    child: const Text("Reset"),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSliderRow(
            l10n.windResistance, 
            _currentParams.windResistance, 
            0.0, 5.0, 
            (val) {
              setState(() => _currentParams = _currentParams.copyWith(windResistance: val));
              _recalculateMetrics();
            }
          ),
          _buildSliderRow(
            l10n.waterResistance, 
            _currentParams.waterResistance, 
            0.0, 50.0, 
            (val) {
              setState(() => _currentParams = _currentParams.copyWith(waterResistance: val));
              _recalculateMetrics();
            }
          ),
          _buildSliderRow(
            l10n.totalMass, 
            _currentParams.totalMass, 
            50.0, 2000.0, 
            (val) {
              setState(() => _currentParams = _currentParams.copyWith(crewTotalWeight: val - _currentParams.boatWeight));
              _recalculateMetrics();
            },
            unit: "kg"
          ),
          const Divider(height: 32),
          Text("Simulation Outcomes", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildOutcomeCard("Total Work", "${_calculatedWork.toStringAsFixed(0)} J", Icons.bolt, Colors.orange),
          const SizedBox(height: 8),
          _buildOutcomeCard("Average Power", "${_calculatedPower.toStringAsFixed(1)} W", Icons.speed, Colors.blue),
          const SizedBox(height: 8),
          _buildOutcomeCard("Avg Impulse", "${_calculatedImpulse.toStringAsFixed(1)} Ns", Icons.keyboard_double_arrow_right, Colors.green),
          const Divider(height: 32),
          Text("Crew Designer (Beta)", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Adjust individual seat weights to see balance impact.", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          _buildCrewDesigner(),
        ],
      ),
    );
  }

  Widget _buildCrewDesigner() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        children: [
          // Simplified Boat Shape
          Center(
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(60), bottom: Radius.circular(20)),
              ),
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 40,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              final weight = _currentParams.crewDistribution[index];
              return GestureDetector(
                onTap: () => _showWeightDialog(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: weight > 0 ? AppColors.contentColorBlue : Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: Text(
                      weight > 0 ? "${weight.toInt()}" : "Row\n${(index / 2 + 1).toInt()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: weight > 0 ? 12 : 8,
                        fontWeight: weight > 0 ? FontWeight.bold : FontWeight.normal,
                        color: weight > 0 ? Colors.white : Colors.white54,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showWeightDialog(int index) {
    double tempWeight = _currentParams.crewDistribution[index];
    if (tempWeight == 0) tempWeight = 75.0; // Default average weight

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Seat ${index + 1} Weight"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${tempWeight.toInt()} kg"),
            Slider(
              value: tempWeight,
              min: 0,
              max: 150,
              divisions: 30,
              onChanged: (val) {
                setState(() => tempWeight = val);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newList = List<double>.from(_currentParams.crewDistribution);
              newList[index] = tempWeight;
              final totalCrewWeight = newList.reduce((a, b) => a + b);
              setState(() {
                _currentParams = _currentParams.copyWith(
                  crewDistribution: newList,
                  crewTotalWeight: totalCrewWeight,
                );
              });
              _recalculateMetrics();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max, ValueChanged<double> onChanged, {String unit = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text("${value.toStringAsFixed(unit == "kg" ? 0 : 2)} $unit", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildOutcomeCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  Widget _buildStatGrid(AppLocalizations l10n) {
    final List<Map<String, String>> stats = [
      {"label": l10n.distance, "value": "${widget.activity.distance.toStringAsFixed(2)} km"},
      {"label": l10n.calories, "value": "${widget.activity.caloriesBurned} kcal"},
      {"label": "${l10n.heartRate} (AVG)", "value": "${widget.activity.averageHeartRate} bpm"},
      {"label": "${l10n.heartRate} (MAX)", "value": "${widget.activity.maxHeartRate} bpm"},
      {"label": l10n.duration, "value": (widget.activity.time).toDisplayFormat()},
      {"label": "Ascent", "value": "${widget.activity.totalAscent} m"},
      {"label": "Best Pace", "value": (widget.activity.bestPace).toDisplayFormat() + " /km"},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return DataDisplayCard(
          label: stats[index]["label"]!,
          value: stats[index]["value"]!,
        );
      },
    );
  }

  Widget _buildSplitsList(AppLocalizations l10n) {
    if (widget.activity.lapsData.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.activity.lapsData.length,
        itemBuilder: (context, index) {
          final lap = widget.activity.lapsData[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text("${lap.index}")),
              title: Text("Dist: ${(lap.distanceMeters / 1000).toStringAsFixed(2)} km | Time: ${Duration(seconds: lap.totalTimeSeconds.toInt()).toDisplayFormat()}"),
              subtitle: Text("Avg HR: ${lap.averageHeartRate} bpm | Max Speed: ${(lap.maxSpeed * 3.6).toStringAsFixed(1)} km/h"),
            ),
          );
        },
      );
    }

    // Fallback to basic Split Logic: Every 500m
    const splitDistance = 0.5; // km
    List<Map<String, dynamic>> splits = [];
    double currentDistance = 0;
    int lastSplitTime = 0;
    
    for (int i = 0; i < details.length; i++) {
      currentDistance += (details[i].speed ?? 0) / 3600; // km/s
      if (currentDistance >= (splits.length + 1) * splitDistance) {
        int splitTime = i - lastSplitTime;
        splits.add({
          "index": splits.length + 1,
          "time": splitTime,
          "pace": splitTime / splitDistance,
        });
        lastSplitTime = i;
      }
    }

    if (splits.isEmpty) {
      return const Center(child: Text("Not enough data for splits (Min. 500m)"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: splits.length,
      itemBuilder: (context, index) {
        final split = splits[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text("${split['index']}")),
            title: Text("Pace: ${(split['pace'] as double).toPaceString()} /500m"),
            subtitle: Text("Time: ${Duration(seconds: (split['time'] as int)).toDisplayFormat()}"),
          ),
        );
      },
    );
  }

  void _exportReport() {
    final csvContent = ExportService.generateActivityCsv(
      widget.activity,
      _currentParams,
      _calculatedWork,
      _calculatedPower,
      _calculatedImpulse,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Export CSV Prototype"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("In a production environment, this would trigger a file download. For this prototype, here is the generated CSV content:", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black,
                child: Text(csvContent, style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: Colors.greenAccent)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    if (details.isEmpty) return 10.0;
    double max = 0;
    if (_showSpeed) {
      for (var d in details) {
        double v = (d.speed ?? 0) * 10; // Scale speed for comparison
        if (v > max) max = v;
      }
    }
    if (_showHR) {
      for (var d in details) {
        if (d.value > max) max = d.value;
      }
    }
    if (_showCadence) {
      for (var d in details) {
        if (d.value2 > max) max = d.value2;
      }
    }
    // Return max + padding (at least 1 unit, or 10% buffer)
    return (max + 1.0) > (max * 1.1) ? (max + 1.0) : (max * 1.1);
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 0) return 1;
    if (maxY <= 5.0) return 1.0;
    if (maxY <= 15.0) return 2.0;
    if (maxY <= 30.0) return 5.0;
    if (maxY <= 100.0) return 20.0;
    if (maxY <= 250.0) return 50.0;
    return (maxY / 5).roundToDouble();
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final barIndex = spot.barIndex;
              // Identifiers based on order in lineBarsData
              // Order: Speed(if on), HR(if on), Cadence(if on)
              int current = 0;
              String label = "";
              if (_showSpeed) {
                if (current == barIndex) label = "${(spot.y / 10).toStringAsFixed(2)} km/h";
                current++;
              }
              if (_showHR && label.isEmpty) {
                if (current == barIndex) label = "${spot.y.toInt()} bpm";
                current++;
              }
              if (_showCadence && label.isEmpty) {
                if (current == barIndex) label = "${spot.y.toInt()} rpm";
                current++;
              }

              return LineTooltipItem(
                label,
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      ),
      gridData: const FlGridData(show: true, drawVerticalLine: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
            int totalSeconds = value.toInt();
            return SideTitleWidget(meta: meta, child: Text('${totalSeconds ~/ 60}:${(totalSeconds % 60).toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 10)));
          }),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, 
            reservedSize: 35, 
            interval: _calculateInterval(_calculateMaxY()),
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey));
            }
          ),
        ),
      ),
      minY: 0,
      maxY: _calculateMaxY(),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d))),
      lineBarsData: [
        if (_showSpeed)
          LineChartBarData(
            spots: details.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), (entry.value.speed?.toDouble() ?? 0) * 10)).toList(),
            isCurved: true,
            color: AppColors.contentColorBlue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: AppColors.contentColorBlue.withOpacity(0.1)),
          ),
        if (_showHR)
          LineChartBarData(
            spots: details.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.value)).toList(),
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        if (_showCadence)
          LineChartBarData(
            spots: details.asMap().entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.value2)).toList(),
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
      ],
    );
  }
}
