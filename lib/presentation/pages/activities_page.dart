import 'package:flutter/material.dart';
import '../../data/repositories/activity_repository.dart';
import '../../domain/entitis/activities.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget
import 'package:dptapp/presentation/pages/pages.dart';
import 'package:dptapp/core/extensions/date_formatter.dart';
import 'package:go_router/go_router.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = ActivityRepositoryImpl().getAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Activity>>(
          future: _activitiesFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              /*
              scrollDirection: Axis.vertical,
              */
              child: PaginatedDataTable(
                header: Text('Activities'),
                columns: [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Distance')),
                  DataColumn(label: Text('Calories Burned')),

                  DataColumn(label: Text('Actions')), // Add Actions column
                ],
                source: ActivityDataSource(snapshot.data!, context),
                rowsPerPage: 10,
                columnSpacing: 10,
                showCheckboxColumn: false,
              ),
            );
          }),
    );
  }
}
class ActivityDataSource extends DataTableSource {
  
  final List<Activity> activities;
  final BuildContext context;

  ActivityDataSource(this.activities, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= activities.length) {
      print("Index out of range: $index"); // 或抛出异常
    }
    final activity = activities[index];
    // 使用 DateFormatter 格式化日期
    // ActivityActivityDate mapping to detail page
    var ActivityActivityDate = (activity.date).toCustomFormat();
    return DataRow(cells: [
      DataCell(Text(activity.title)),
      DataCell(Text(activity.activityType)),
      //DataCell(Text(activity.date.toString())),
      DataCell(Text(ActivityActivityDate.toString())),
      DataCell(Text(activity.distance.toString())),
      DataCell(Text(activity.caloriesBurned.toString())),
      DataCell(
        //TextButton(
        IconButton( 
          onPressed: () {
// Navigate to detail page or perform any action
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(),
              ),
            );
        */
//contextgo('/detail');
            context.go('/detail', extra: activity);
          },
          //child: Text('Details'),
          icon: Icon(Icons.query_stats), // 使用 "資訊" 圖示
          tooltip: '詳細資訊',
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => activities.length;

  @override
  int get selectedRowCount => 0;
}
/*
// Dummy DetailPage for demonstration
class DetailPage extends StatelessWidget {
  final Activity activity;

  DetailPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${activity.title}'),
            Text('Activity Type: ${activity.activityType}'),
            Text('Date: ${activity.date}'),
            Text('Distance: ${activity.distance}'),
            Text('Calories Burned: ${activity.caloriesBurned}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
*/

/*
import 'package:dptapp/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/activity_repository.dart';
import '../../domain/entitis/activities.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = ActivityRepositoryImpl().getAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Activity>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activities found.'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Distance')),
                  DataColumn(label: Text('Calories Burned')),
                  DataColumn(label: Text('Details')),
                ],
                rows: snapshot.data!.map((activity) {
                  return DataRow(cells: [
                    DataCell(Text(activity.title)),
                    DataCell(Text(activity.activityType)),
                    DataCell(Text(activity.date.toString())),
                    DataCell(Text(activity.distance.toString())),
                    DataCell(Text(activity.caloriesBurned.toString())),
                       DataCell(
                        TextButton(
                          onPressed: () {
                            // Navigate to detail page or perform any action
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );
                          },
                          child: Text('Details'),
                        ),
                      ),                   
                  ]);
                }).toList(),
              ),
            )
            );
          }
        },
      ),
    );
  }
}
*/
