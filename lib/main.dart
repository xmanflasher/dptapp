import 'package:flutter/material.dart';
import 'package:dptapp/features/activities/domain/activity_repository.dart';
import 'package:dptapp/features/activities/data/activity_repository_impl.dart';
import 'package:dptapp/features/activities/domain/detail_repository.dart';
import 'package:dptapp/features/activities/data/detail_repository_impl.dart';
import 'package:dptapp/features/auth/domain/auth_repository.dart';
import 'package:dptapp/features/auth/data/auth_repository_impl.dart';
import 'package:dptapp/features/settings/domain/settings_repository.dart';
import 'package:dptapp/features/settings/data/settings_repository_impl.dart';
import 'package:dptapp/features/training/domain/training_repository.dart';
import 'package:dptapp/features/training/data/training_repository_impl.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:dptapp/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:dptapp/features/training/presentation/bloc/training_cubit.dart';
import 'package:dptapp/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:dptapp/shared/bloc/timer/timer_bloc.dart';
import 'package:dptapp/features/activities/presentation/bloc/playback_cubit.dart';
import 'package:dptapp/features/activities/presentation/bloc/raw_data_bloc.dart';
import 'package:dptapp/features/training/presentation/bloc/bluetooth_chart_cubit.dart';
import 'package:dptapp/ini.dart';
import 'package:dptapp/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies and get the environment
  final currentEnv = await AppIni.configureDependencies();

  runApp(DbtApp());
}