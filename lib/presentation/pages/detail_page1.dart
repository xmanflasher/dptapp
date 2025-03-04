import 'package:flutter/material.dart';
import '../../data/repositories/detail_repository.dart';
import '../../domain/entities/detail.dart';
import '../widgets/navigation_drawer_widget.dart'; // Import the NavigationDrawerWidget
import 'package:dptapp/presentation/pages/pages.dart';

//先確定資料串進後再修UI方便測試
class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<Detail>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = DetailRepositoryImpl().getAllDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      drawer: NavigationDrawerWidget(), // Add the NavigationDrawerWidget here
      body: FutureBuilder<List<Detail>>(
          future: _detailFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              /*
              scrollDirection: Axis.vertical,
              */
              child: PaginatedDataTable(
                header: Text('Detail'),
                columns: [
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Speed')),
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Intensity')),
                  DataColumn(label: Text('AvgSpeed')),
                  
                  DataColumn(label: Text('Actions')), // Add Actions column
                  
                ],
                source: DetailDataSource(snapshot.data!, context),
                rowsPerPage: 10,
                columnSpacing: 10,
                showCheckboxColumn: false,
              ),
            );
          }),
    );
  }
}
//先確定資料串進後再修UI方便測試
class DetailDataSource extends DataTableSource {
  final List<Detail> details;
  final BuildContext context;

  DetailDataSource(this.details, this.context);

  @override
  DataRow getRow(int index) {
    if (index >= details.length) {
      print("Index out of range: $index"); // 或抛出异常
    }
    final detail = details[index];
    return DataRow(cells: [
      DataCell(Text(detail.time.toString())),
      DataCell(Text(detail.speed.toString())),
      DataCell(Text(detail.id.toString())),
      DataCell(Text(detail.intensity.toString())),
      DataCell(Text(detail.avgSpeed.toString())),
      
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
          child: Text('Detail'),
        ),
      ),
      
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => details.length;

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