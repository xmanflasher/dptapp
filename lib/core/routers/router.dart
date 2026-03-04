import 'package:flutter/material.dart';
import 'package:dptapp/ini.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/pages/pages.dart';
import '../../domain/entities/activities.dart';
import '../../presentation/widgets/shell_navigation.dart';
import 'app_routes.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _activitiesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'activities');
final GlobalKey<NavigatorState> _trainingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'training');
final GlobalKey<NavigatorState> _communityNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'community');
final GlobalKey<NavigatorState> _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
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
      builder: (context, state) => const LoginPage(),
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
          navigatorKey: _activitiesNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.activities,
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
