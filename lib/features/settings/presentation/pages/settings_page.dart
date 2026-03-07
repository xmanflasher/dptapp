import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:dptapp/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:dptapp/features/settings/domain/user_config.dart';
import 'package:dptapp/shared/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:dptapp/shared/widgets/shell_navigation.dart';
import 'package:dptapp/shared/widgets/global_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final profile = authState.user;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: GlobalAppBar(
            title: l10n.settings,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => ShellNavigation.shellScaffoldKey.currentState?.openDrawer(),
            ),
          ),
          body: BlocBuilder<SettingsCubit, UserConfig>(
            builder: (context, settings) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle(l10n.language),
                  ListTile(
                    title: Text(settings.language == 'zh' ? '繁體中文' : 'English'),
                    trailing: const Icon(Icons.language),
                    onTap: () {
                      final newLang = settings.language == 'zh' ? 'en' : 'zh';
                      context.read<SettingsCubit>().updateSettings(
                            settings.copyWith(language: newLang),
                          );
                    },
                  ),
                  const Divider(),
                  _buildSectionTitle(l10n.themeMode),
                  _buildThemeSelector(context, settings),
                  const Divider(),
                  _buildSectionTitle(l10n.units),
                  SwitchListTile(
                    title: Text(settings.useMetric ? l10n.metric : l10n.imperial),
                    value: settings.useMetric,
                    onChanged: (val) {
                      context.read<SettingsCubit>().updateSettings(
                            settings.copyWith(useMetric: val),
                          );
                    },
                  ),
                  const Divider(),
                  _buildSectionTitle(l10n.weight),
                  ListTile(
                    title: Text("${settings.userWeight} kg"),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _showWeightDialog(context, settings),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, UserConfig settings) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _themeButton(context, ThemeMode.light, l10n.light, Icons.light_mode),
        _themeButton(context, ThemeMode.dark, l10n.dark, Icons.dark_mode),
        _themeButton(context, ThemeMode.system, l10n.system, Icons.brightness_auto),
      ],
    );
  }

  Widget _themeButton(BuildContext context, ThemeMode mode, String label, IconData icon) {
    final currentMode = context.watch<ThemeCubit>().state;
    final isSelected = currentMode == mode;
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          onPressed: () {
            context.read<ThemeCubit>().updateTheme(mode);
            final settings = context.read<SettingsCubit>().state;
            context.read<SettingsCubit>().updateSettings(
              settings.copyWith(themeMode: mode.name),
            );
          },
        ),
        Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.blue : Colors.grey)),
      ],
    );
  }

  void _showWeightDialog(BuildContext context, UserConfig settings) {
    final controller = TextEditingController(text: settings.userWeight.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Weight"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: "kg"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(controller.text) ?? settings.userWeight;
              context.read<SettingsCubit>().updateSettings(settings.copyWith(userWeight: weight));
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}


