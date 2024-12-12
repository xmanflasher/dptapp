import 'package:hive_flutter/hive_flutter.dart';

class Env {
  const Env._();

  static const mock = 'mock';
  static const dev = 'dev';
  static const sit = 'sit';
}

class AppIni {
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox('timerBox');
  }

  static Future<String> configureDependencies() async {
    // Here you can add logic to determine the environment
    // For example, you can read from a configuration file or environment variables
    // For simplicity, we'll just return the dev environment
    const currentEnv = Env.dev;

    // Initialize Hive
    await initializeHive();

    return currentEnv;
  }
}