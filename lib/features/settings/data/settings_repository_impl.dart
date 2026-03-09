import 'package:hive_flutter/hive_flutter.dart';
import 'package:dptapp/features/settings/domain/user_config.dart';
import 'package:dptapp/features/settings/domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final Box _box;
  static const String _key = 'current_config';

  SettingsRepositoryImpl(this._box);

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

  @override
  Future<String> getLanguage() async {
    final config = await getSettings();
    return config.language;
  }

  @override
  Future<void> setLanguage(String language) async {
    final config = await getSettings();
    await saveSettings(config.copyWith(language: language));
  }

  @override
  Future<String> getThemeMode() async {
    final config = await getSettings();
    return config.themeMode;
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    final config = await getSettings();
    await saveSettings(config.copyWith(themeMode: themeMode));
  }

  @override
  Future<List<String>> getHomeWidgetOrder() async {
    final config = await getSettings();
    return config.homeWidgetOrder;
  }

  @override
  Future<void> setHomeWidgetOrder(List<String> order) async {
    final config = await getSettings();
    await saveSettings(config.copyWith(homeWidgetOrder: order));
  }

  @override
  Future<Map<String, bool>> getHomeWidgetVisibility() async {
    final config = await getSettings();
    return config.homeWidgetVisibility;
  }

  @override
  Future<void> setHomeWidgetVisibility(Map<String, bool> visibility) async {
    final config = await getSettings();
    await saveSettings(config.copyWith(homeWidgetVisibility: visibility));
  }
}
