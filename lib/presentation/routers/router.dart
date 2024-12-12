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
      path: '/record',
      builder: (context, state) => const RecordPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/syncrecording',
      builder: (context, state) => const SyncrecordingPage(),
    ),
  ],
);
