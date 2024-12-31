import 'package:hive_flutter/hive_flutter.dart';

class Env {
  const Env._();

  static const mock = 'mock';
  static const dev = 'dev';
  static const sit = 'sit';
}

class AppIni {
  static String currentEnv = Env.mock; // Default to mock environment

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox('timerBox');
  }

  static Future<String> configureDependencies() async {
    // Here you can add logic to determine the environment
    // For example, you can read from a configuration file or environment variables
    // For simplicity, we'll just set the dev environment
    currentEnv = Env.mock;
    // Initialize Hive
    await initializeHive();

    return currentEnv;
  }
  
}