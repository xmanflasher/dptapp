import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/domain/user_profile.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/theme/app_theme.dart';

class TrainingDisplaySettingsSheet extends StatelessWidget {
  final UserProfile profile;

  const TrainingDisplaySettingsSheet({super.key, required this.profile});

  static void show(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrainingDisplaySettingsSheet(profile: profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trainingConfig =
        Map<String, dynamic>.from(profile.preferences['training_config'] ?? {});
    final List<String> visibleMetrics = List<String>.from(
        trainingConfig['visible_metrics'] ??
            ['speed', 'cadence', 'power', 'work', 'sync']);
    final List<String> layoutOrder =
        List<String>.from(trainingConfig['layout_order'] ?? ['hud', 'chart']);
    final List<String> visibleModules =
        List<String>.from(trainingConfig['visible_modules'] ?? ['hud', 'chart']);
    final int interval = trainingConfig['chart_interval'] ?? 30;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.displaySettings,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.metricVisibility,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              _buildToggleItem(setModalState, l10n.mainMetricSpeed, 'speed',
                  visibleMetrics, trainingConfig, profile, context),
              _buildToggleItem(setModalState, l10n.cadenceLabel, 'cadence',
                  visibleMetrics, trainingConfig, profile, context),
              _buildToggleItem(setModalState, l10n.powerWattsLabel, 'power',
                  visibleMetrics, trainingConfig, profile, context),
              _buildToggleItem(setModalState, l10n.workImpulseLabel, 'work',
                  visibleMetrics, trainingConfig, profile, context),
              _buildToggleItem(setModalState, l10n.syncStatusLabel, 'sync',
                  visibleMetrics, trainingConfig, profile, context),
              const Divider(height: 32),
              Text(l10n.layoutModules,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              ...layoutOrder.map((key) => _buildLayoutItem(
                  setModalState,
                  key == 'hud' ? l10n.liveHudCard : l10n.performanceChartLabel,
                  key,
                  layoutOrder,
                  visibleModules,
                  trainingConfig,
                  profile,
                  context)),
              const Divider(height: 32),
              Text(l10n.horizontalAxisInterval,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(height: 16),
              Row(
                children: [30, 60, 90]
                    .map((v) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text("${v}s"),
                            selected: interval == v,
                            onSelected: (selected) {
                              if (selected) {
                                trainingConfig['chart_interval'] = v;
                                context.read<AuthCubit>().updateProfile(
                                      profile.copyWith(
                                        preferences: {
                                          ...profile.preferences,
                                          'training_config': trainingConfig,
                                        },
                                      ),
                                    );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleItem(
      StateSetter setModalState,
      String label,
      String key,
      List<String> visibleMetrics,
      Map trainingConfig,
      UserProfile profile,
      BuildContext context) {
    final isActive = visibleMetrics.contains(key);

    return ListTile(
      title: Text(label),
      trailing: Switch(
        value: isActive,
        onChanged: (value) {
          setModalState(() {
            if (value) {
              if (!visibleMetrics.contains(key)) visibleMetrics.add(key);
            } else {
              visibleMetrics.remove(key);
            }
          });
          trainingConfig['visible_metrics'] = visibleMetrics;
          context.read<AuthCubit>().updateProfile(
                profile.copyWith(
                  preferences: {
                    ...profile.preferences,
                    'training_config': trainingConfig,
                  },
                ),
              );
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLayoutItem(
      StateSetter setModalState,
      String label,
      String key,
      List<String> layoutOrder,
      List<String> visibleModules,
      Map trainingConfig,
      UserProfile profile,
      BuildContext context) {
    final isActive = visibleModules.contains(key);

    return ListTile(
      title: Text(label),
      leading: IconButton(
        icon: const Icon(Icons.swap_vert, color: Colors.blue),
        onPressed: () {
          setModalState(() {
            if (layoutOrder.length >= 2) {
              final idx = layoutOrder.indexOf(key);
              final otherIdx = idx == 0 ? 1 : 0;
              final temp = layoutOrder[idx];
              layoutOrder[idx] = layoutOrder[otherIdx];
              layoutOrder[otherIdx] = temp;
            }
          });
          trainingConfig['layout_order'] = layoutOrder;
          context.read<AuthCubit>().updateProfile(
                profile.copyWith(
                  preferences: {
                    ...profile.preferences,
                    'training_config': trainingConfig,
                  },
                ),
              );
        },
      ),
      trailing: Switch(
        value: isActive,
        onChanged: (value) {
          setModalState(() {
            if (value) {
              if (!visibleModules.contains(key)) visibleModules.add(key);
            } else {
              visibleModules.remove(key);
            }
          });
          trainingConfig['visible_modules'] = visibleModules;
          context.read<AuthCubit>().updateProfile(
                profile.copyWith(
                  preferences: {
                    ...profile.preferences,
                    'training_config': trainingConfig,
                  },
                ),
              );
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
