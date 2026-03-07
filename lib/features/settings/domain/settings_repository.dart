import 'package:dptapp/features/settings/domain/user_config.dart';

abstract class SettingsRepository {
  Future<UserConfig> getSettings();
  Future<void> saveSettings(UserConfig config);

  Future<String> getLanguage();
  Future<void> setLanguage(String language);
  
  Future<String> getThemeMode();
  Future<void> setThemeMode(String themeMode);
  
  Future<List<String>> getHomeWidgetOrder();
  Future<void> setHomeWidgetOrder(List<String> order);
  
  Future<Map<String, bool>> getHomeWidgetVisibility();
  Future<void> setHomeWidgetVisibility(Map<String, bool> visibility);
}
