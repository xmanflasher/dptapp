import 'package:equatable/equatable.dart';

class UserConfig extends Equatable {
  final String language; // 'en' or 'zh'
  final String themeMode; // 'light', 'dark', 'system'
  final bool useMetric;
  final double userWeight; // in kg
  final int userAge;
  final Map<String, int> hrZones; // e.g., {'Z1': 120, 'Z2': 140, ...}
  final Map<String, int> powerZones;

  const UserConfig({
    this.language = 'zh',
    this.themeMode = 'system',
    this.useMetric = true,
    this.userWeight = 75.0,
    this.userAge = 30,
    this.hrZones = const {'Z1': 110, 'Z2': 130, 'Z3': 150, 'Z4': 170, 'Z5': 190},
    this.powerZones = const {'Z1': 100, 'Z2': 150, 'Z3': 200, 'Z4': 250, 'Z5': 300},
  });

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'themeMode': themeMode,
      'useMetric': useMetric,
      'userWeight': userWeight,
      'userAge': userAge,
      'hrZones': hrZones,
      'powerZones': powerZones,
    };
  }

  factory UserConfig.fromMap(Map<String, dynamic> map) {
    return UserConfig(
      language: map['language'] ?? 'zh',
      themeMode: map['themeMode'] ?? 'system',
      useMetric: map['useMetric'] ?? true,
      userWeight: (map['userWeight'] as num?)?.toDouble() ?? 75.0,
      userAge: map['userAge'] ?? 30,
      hrZones: Map<String, int>.from(map['hrZones'] ?? {}),
      powerZones: Map<String, int>.from(map['powerZones'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [language, themeMode, useMetric, userWeight, userAge, hrZones, powerZones];
}
