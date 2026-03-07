import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/activities/domain/activity_repository.dart';
import 'package:dptapp/features/activities/data/activity_repository_impl.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/parsers/date_formatter.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:dptapp/core/routers/app_routes.dart';
import 'package:dptapp/shared/widgets/global_app_bar.dart';
import 'package:dptapp/shared/widgets/navigation_drawer_widget.dart';
import 'package:dptapp/shared/widgets/shell_navigation.dart';
import 'package:go_router/go_router.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => ActivitiesPageState();
}

class ActivitiesPageState extends State<ActivitiesPage> {
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = ActivityRepositoryImpl().getAllActivities();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final profile = authState.user;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: GlobalAppBar(
            title: 'Activities',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go(AppRoutes.cycle),
            ),
          ),
          body: FutureBuilder<List<Activity>>(
              future: _activitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No activities found"));
                }
                
                return SingleChildScrollView(
                  child: Theme(
                    data: theme.copyWith(
                      cardTheme: CardTheme(
                        color: theme.cardColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.primaryColor.withValues(alpha: 0.2), width: 1),
                        ),
                      ),
                    ),
                    child: PaginatedDataTable(
                      header: const Text(
                        'History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      columns: const [
                        DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Dist', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Cal', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      source: ActivityDataSource(snapshot.data!, context),
                      rowsPerPage: 10,
                      columnSpacing: 20,
                      showCheckboxColumn: false,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}

class ActivityDataSource extends DataTableSource {
  final List<Activity> activities;
  final BuildContext context;

  ActivityDataSource(this.activities, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= activities.length) {
      return null;
    }
    final activity = activities[index];
    final activityDate = (activity.date).toCustomFormat();
    return DataRow(cells: [
      DataCell(Text(activity.title)),
      DataCell(Text(activity.activityType)),
      DataCell(Text(activityDate.toString())),
      DataCell(Text(activity.distance.toString())),
      DataCell(Text(activity.caloriesBurned.toString())),
      DataCell(
        IconButton(
          onPressed: () {
            context.go('/detail', extra: activity);
          },
          icon: const Icon(Icons.query_stats),
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
