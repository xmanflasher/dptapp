import 'package:flutter/material.dart';
import 'ini.dart';
import 'landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies and get the environment
  final currentEnv = await AppIni.configureDependencies();

  runApp(DbtApp(env: currentEnv));
}