import 'package:flutter/material.dart';
import '../../data/repositories/record_repository.dart';
import '../../domain/entitis/records.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget
import 'package:dptapp/presentation/pages/pages.dart';
import 'package:dptapp/core/extensions/date_formatter.dart';
import 'package:go_router/go_router.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late Future<List<Record>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = RecordRepositoryImpl().getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Record>>(
          future: _recordsFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              /*
              scrollDirection: Axis.vertical,
              */
              child: PaginatedDataTable(
                header: Text('Records'),
                columns: [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Distance')),
                  DataColumn(label: Text('Calories Burned')),

                  DataColumn(label: Text('Actions')), // Add Actions column
                ],
                source: RecordDataSource(snapshot.data!, context),
                rowsPerPage: 10,
                columnSpacing: 10,
                showCheckboxColumn: false,
              ),
            );
          }),
    );
  }
}

class RecordDataSource extends DataTableSource {
  final List<Record> records;
  final BuildContext context;

  RecordDataSource(this.records, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= records.length) {
      print("Index out of range: $index"); // 或抛出异常
    }
    final record = records[index];
    // 使用 DateFormatter 格式化日期
    // ActivityRecordDate mapping to detail page
    var ActivityRecordDate = (record.date).toCustomFormat();
    return DataRow(cells: [
      DataCell(Text(record.title)),
      DataCell(Text(record.activityType)),
      //DataCell(Text(record.date.toString())),
      DataCell(Text(ActivityRecordDate.toString())),
      DataCell(Text(record.distance.toString())),
      DataCell(Text(record.caloriesBurned.toString())),
      DataCell(
        TextButton(
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
            context.go('/detail/${record.date}');
          },
          child: Text('Details'),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => records.length;

  @override
  int get selectedRowCount => 0;
}
/*
// Dummy DetailPage for demonstration
class DetailPage extends StatelessWidget {
  final Record record;

  DetailPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${record.title}'),
            Text('Activity Type: ${record.activityType}'),
            Text('Date: ${record.date}'),
            Text('Distance: ${record.distance}'),
            Text('Calories Burned: ${record.caloriesBurned}'),
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
import '../../data/repositories/record_repository.dart';
import '../../domain/entitis/records.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  late Future<List<Record>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = RecordRepositoryImpl().getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Record>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found.'));
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
                rows: snapshot.data!.map((record) {
                  return DataRow(cells: [
                    DataCell(Text(record.title)),
                    DataCell(Text(record.activityType)),
                    DataCell(Text(record.date.toString())),
                    DataCell(Text(record.distance.toString())),
                    DataCell(Text(record.caloriesBurned.toString())),
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
