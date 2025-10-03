import 'package:dptapp/ini.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/pages.dart';
import '../../domain/entities/activities.dart';

part 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: AppRoutes.activities,
      builder: (context, state) => ActivitiesPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.syncrecording,
      builder: (context, state) => const SyncrecordingPage(),
    ),
    GoRoute(
      path: AppRoutes.detail,
      builder: (context, state) {
        final activity = state.extra as Activity;
        return DetailPage(activity: activity);
      },
    ),
    GoRoute(
      path: AppRoutes.test,
      builder: (context, state) => TestPage(),
    ),
  ],
);
