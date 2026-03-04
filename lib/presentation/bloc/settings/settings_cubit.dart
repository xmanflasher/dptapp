import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_config.dart';
import '../../../data/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<UserConfig> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(const UserConfig());

  Future<void> loadSettings() async {
    final settings = await _settingsRepository.getSettings();
    emit(settings);
  }

  Future<void> updateSettings(UserConfig newConfig) async {
    await _settingsRepository.saveSettings(newConfig);
    emit(newConfig);
  }
}
