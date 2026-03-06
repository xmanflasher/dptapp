import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'presentation/bloc/bloc.dart';
import 'core/routers/router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/resources/app_theme.dart';
import 'domain/entities/user_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';

class DbtApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepositoryImpl();

  DbtApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = SettingsRepositoryImpl(Hive.box('settings'));

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider<SettingsRepository>.value(value: settingsRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(authRepository)),
          BlocProvider(create: (context) => BluetoothBloc()),
          BlocProvider(create: (context) => TimerBloc()),
          BlocProvider(create: (context) => SettingsCubit(settingsRepo)..loadSettings()),
          BlocProvider(create: (context) => ThemeCubit(settingsRepo)..loadTheme()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(context.read<AuthCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<SettingsCubit, UserConfig>(
          builder: (context, settings) {
            return MaterialApp.router(
              title: 'Dragon Boat Performance',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: Locale(settings.language),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('zh'),
              ],
              routerConfig: _router,
            );
          },
        );
      },
    );
  }
}