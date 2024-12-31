import 'package:flutter/material.dart';
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
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Distance')),
                  DataColumn(label: Text('Calories Burned')),
                ],
                rows: snapshot.data!.map((record) {
                  return DataRow(cells: [
                    DataCell(Text(record.title)),
                    DataCell(Text(record.activityType)),
                    DataCell(Text(record.date.toString())),
                    DataCell(Text(record.distance.toString())),
                    DataCell(Text(record.caloriesBurned.toString())),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}