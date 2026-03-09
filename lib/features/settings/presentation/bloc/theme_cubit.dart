import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/settings/domain/settings_repository.dart';

class ThemeCubit extends Cubit<String> {
  final SettingsRepository _settingsRepository;

  ThemeCubit(this._settingsRepository) : super('system');

  Future<void> loadTheme() async {
    final settings = await _settingsRepository.getSettings();
    emit(settings.themeMode);
  }

  void updateTheme(String mode) {
    emit(mode);
  }
}
