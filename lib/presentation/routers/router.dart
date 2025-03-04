import 'package:dptapp/ini.dart';
import 'package:go_router/go_router.dart';
import '../pages/pages.dart';
import '../../domain/entities/activities.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/Activities',
      builder: (context, state) => ActivitiesPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/syncrecording',
      builder: (context, state) => const SyncrecordingPage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final activity = state.extra as Activity;
        return DetailPage(activity: activity);
      },
    ),
  ],
);
