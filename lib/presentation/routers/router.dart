import 'package:dptapp/ini.dart';
import 'package:go_router/go_router.dart';
import '../pages/pages.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/records',
      builder: (context, state) => RecordsPage(),
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
      builder: (context, state) => DetailPage(),
    ),
  ],
);
