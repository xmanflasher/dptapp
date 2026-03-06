import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_config.dart';
import '../../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<UserConfig> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(const UserConfig());

  Future<void> loadSettings() async {
    final config = await _settingsRepository.getSettings();
    emit(config);
  }

  Future<void> updateSettings(UserConfig newConfig) async {
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }

  Future<void> updateLanguage(String language) async {
    final newConfig = state.copyWith(language: language);
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }

  Future<void> updateThemeMode(String themeMode) async {
    final newConfig = state.copyWith(themeMode: themeMode);
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }

  Future<void> updateHomeWidgetOrder(List<String> order) async {
    final newConfig = state.copyWith(homeWidgetOrder: order);
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }

  Future<void> updateHomeWidgetVisibility(Map<String, bool> visibility) async {
    final newConfig = state.copyWith(homeWidgetVisibility: visibility);
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }
}
