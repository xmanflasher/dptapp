import 'package:fl_chart/fl_chart.dart';
import 'package:dptapp/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget
import '../../data/repositories/detail_repository.dart';
import '../../domain/entities/detail.dart';
import '../../domain/entities/activities.dart';
import 'package:dptapp/core/extensions/duration_formatter.dart';

class DetailPage extends StatefulWidget {
  //final DateTime activityActivityDate;
  final Activity activity;
  const DetailPage({Key? key, required this.activity}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  late TabController _tabController;
  late Future<List<Detail>> _detailFuture;
  List<Detail> details = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 初始化 TabController
    //_detailFuture = DetailRepositoryImpl().getAllDetail();
    _detailFuture =
        DetailRepositoryImpl().getDetailByDate(widget.activity.date);
  }

  @override
  void dispose() {
    _tabController.dispose(); // 銷毀 TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Detail>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No details found.'));
          } else {
            details = snapshot.data!;
            return Column(
              children: [
                // 上半部分顯示圖表
                Expanded(
                  flex: 1, // 分配較大的空間給圖表
                  child: Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Padding(
                          /*
                          padding: const EdgeInsets.only(
                            right: 18,
                            left: 12,
                            top: 24,
                            bottom: 12,
                          ),
                          */
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LineChart(
                            mainData(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 下半部分顯示 TabBar 和 TabBarView
                Expanded(
                  flex: 1, // 分配較小的空間給 TabBar 和內容
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.contentColorCyan,
                        tabs: const [
                          Tab(text: '統計數據'),
                          Tab(text: '分趟數據'),
                          Tab(text: '心肺區間'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // 🔹 統計數據 Tab
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildStatGrid(),
                        ),
                      ),

                      // 分趟數據 Tab
                      const Center(child: Text('分趟數據內容（待新增）')),

                      // 心肺區間 Tab
                      const Center(child: Text('心肺區間內容（待新增）')),
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
  // 🔹 使用 GridView 讓數據分成兩半顯示
  Widget _buildStatGrid() {
    final List<Map<String, String>> stats = [
      {"label": "距離", "value": "${widget.activity.distance} 公里"},
      {"label": "卡路里", "value": "${widget.activity.caloriesBurned} kcal"},
      {"label": "心率 (平均)", "value": "${widget.activity.averageHeartRate} bpm"},
      {"label": "心率 (最大)", "value": "${widget.activity.maxHeartRate} bpm"},
      //{"label": "計時", "value": "${widget.activity.time} 分鐘"},
      {"label": "計時", "value": (widget.activity.time).toDisplayFormat()},
      {"label": "總攀爬高度", "value": "${widget.activity.totalAscent} 公尺"},
      //{"label": "最佳配速", "value": "${widget.activity.bestPace} 分鐘/公里"},
      {"label": "最佳配速", "value": (widget.activity.bestPace).toDisplayFormat() +" /公里"},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // 禁止 GridView 滾動
      shrinkWrap: true, // 讓 GridView 根據內容大小調整
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 🔹 讓數據分成兩列
        crossAxisSpacing: 16.0, // 列之間的間距
        mainAxisSpacing: 8.0, // 行之間的間距
        childAspectRatio: 3, // 控制方塊的寬高比例
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return _buildStatItem(stats[index]["label"]!, stats[index]["value"]!);
      },
    );
  }
  Widget _buildStatItem(String label, String value) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2, // 兩個並排
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

/*
// 🔹 提取成共用的小組件
  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
*/
  // 以下方法保持不變，主要用於圖表的設置
/*
//原範例
  Widget bottomTitleWidgets_O(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }
  */
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // 假設 value 是秒數，轉換成 mm:ss
    int totalSeconds = value.toInt();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return SideTitleWidget(
      meta: meta,
      child: Text(formattedTime, style: style),
    );
  }

/*
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
*/
  LineChartData mainData() {
    return LineChartData(
      //TouchData
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          //getTooltipColor: (spot) => AppColors.mainTooltipBgColor,
          tooltipBorder: BorderSide(color: AppColors.tooltipBgColor),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(2)} km/h',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
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
            maxIncluded: false,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            maxIncluded: false,
            minIncluded: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: details.length.toDouble() - 1,
      minY: 0,
      maxY: details
          .map((detail) => detail.speed ?? 0)
          .reduce((a, b) => a > b ? a : b),
      //maxY: details.map((detail) => detail.speed).reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: details
              .asMap()
              .entries
              .map((entry) => FlSpot(
                  entry.key.toDouble(), entry.value.speed?.toDouble() ?? 0))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

/*
//平均值範例
  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
    );
  }
  */
}
