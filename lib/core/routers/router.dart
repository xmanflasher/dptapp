import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dptapp/ini.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/features/auth/presentation/pages/login_page.dart';
import 'package:dptapp/features/settings/presentation/pages/settings_page.dart';
import 'package:dptapp/features/settings/presentation/pages/test_page.dart';
import 'package:dptapp/features/home/presentation/pages/home_page.dart';
import 'package:dptapp/features/activities/presentation/pages/activities_page.dart';
import 'package:dptapp/features/training/presentation/pages/syncrecording_page.dart';
import 'package:dptapp/features/activities/presentation/pages/detail_page.dart';
import 'package:dptapp/features/training/presentation/pages/training_page.dart';
import 'package:dptapp/features/cycle/presentation/pages/cycle_page.dart';
import 'package:dptapp/features/community/presentation/pages/community_page.dart';
import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/shared/widgets/shell_navigation.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'app_routes.dart';

// Helper for GoRouter to listen to streams
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _cycleNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'cycle');
final GlobalKey<NavigatorState> _trainingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'training');
final GlobalKey<NavigatorState> _communityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'community');
final GlobalKey<NavigatorState> _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

GoRouter createRouter(AuthCubit authCubit) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  refreshListenable: GoRouterRefreshStream(authCubit.stream),
  redirect: (context, state) {
    final authState = authCubit.state;
    final loggingIn = state.matchedLocation == AppRoutes.login;

    if (authState.status == AuthStatus.unknown) return null;

    if (authState.status != AuthStatus.authenticated) {
      return loggingIn ? null : AppRoutes.login;
    }

    if (loggingIn) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return ShellNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const MyHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _cycleNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.cycle,
              builder: (context, state) => const CyclePage(),
              routes: [
                GoRoute(
                  path: 'activities',
                  builder: (context, state) => ActivitiesPage(),
                  routes: [
                    GoRoute(
                      path: 'detail',
                      builder: (context, state) {
                        if (state.extra is! Activity) {
                          return ActivitiesPage();
                        }
                        final activity = state.extra as Activity;
                        return DetailPage(activity: activity);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _trainingNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.training,
              builder: (context, state) => const TrainingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _communityNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.community,
              builder: (context, state) => const CommunityPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    // Routes that should be pushed on top of everything
    GoRoute(
      path: AppRoutes.syncrecording,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SyncrecordingPage(),
    ),
    GoRoute(
      path: AppRoutes.detail, // Keeping absolute path for backward compatibility
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        if (state.extra is! Activity) {
          // Fallback if accessed via direct URL or reload on web
          return ActivitiesPage(); 
        }
        final activity = state.extra as Activity;
        return DetailPage(activity: activity);
      },
    ),
    GoRoute(
      path: AppRoutes.test,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => TestPage(),
    ),
  ],
);
