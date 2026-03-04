import 'package:hive/hive.dart';
import '../../domain/entities/user_config.dart';

abstract class SettingsRepository {
  Future<UserConfig> getSettings();
  Future<void> saveSettings(UserConfig config);
}

class HiveSettingsRepository implements SettingsRepository {
  final Box _box = Hive.box('userSettings');
  static const String _key = 'current_config';

  @override
  Future<UserConfig> getSettings() async {
    final data = _box.get(_key);
    if (data == null) return const UserConfig();
    return UserConfig.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> saveSettings(UserConfig config) async {
    await _box.put(_key, config.toMap());
  }
}
