import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/core/routers/app_routes.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/features/auth/presentation/widgets/profile_dialog.dart';
import 'package:dptapp/features/training/presentation/widgets/training_display_settings_sheet.dart';
import 'package:dptapp/features/training/presentation/widgets/simulation_config_dialog.dart';
import 'package:dptapp/features/training/presentation/bloc/training_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      leading: leading,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            _showMockNotifications(context);
          },
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final profile = authState.user;

            Widget avatarWidget;
            if (profile == null) {
              avatarWidget = const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              );
            } else {
              avatarWidget = CircleAvatar(
                radius: 16,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                child: profile.avatarUrl == null
                    ? Icon(Icons.person, size: 20, color: theme.primaryColor)
                    : null,
              );
            }

            return Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: profile == null
                  ? avatarWidget
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        final l10n = AppLocalizations.of(context)!;
                        switch (value) {
                          case 'edit':
                            _showProfileDialog(context, profile);
                            break;
                          case 'dashboard':
                            context.push(AppRoutes.dashboardSettings,
                                extra: profile);
                            break;
                          case 'training_settings':
                            _showTrainingSettings(context, profile);
                            break;
                          case 'sim_config':
                            _showSimConfig(context);
                            break;
                          case 'sync':
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.syncRecords + "...")),
                            );
                            break;
                          case 'logout':
                            context.read<AuthCubit>().logout();
                            context.go(AppRoutes.login);
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: const Icon(Icons.edit_outlined),
                              title: Text(l10n.editProfile),
                              dense: true,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'dashboard',
                            child: ListTile(
                              leading: const Icon(Icons.dashboard_customize_outlined),
                              title: Text(l10n.homeDashboard),
                              dense: true,
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'training_settings',
                            child: ListTile(
                              leading: const Icon(Icons.tune),
                              title: Text(l10n.trainingDisplay),
                              dense: true,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'sim_config',
                            child: ListTile(
                              leading: const Icon(Icons.settings_input_component),
                              title: Text(l10n.simParameters),
                              dense: true,
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'sync',
                            child: ListTile(
                              leading: const Icon(Icons.sync),
                              title: Text(l10n.syncRecords),
                              dense: true,
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'logout',
                            child: ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.redAccent),
                              title: Text(l10n.logout,
                                  style: const TextStyle(color: Colors.redAccent)),
                              dense: true,
                            ),
                          ),
                        ];
                      },
                      child: avatarWidget,
                    ),
            );
          },
        ),
      ],
    );
  }

  void _showMockNotifications(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.notifications,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.people, color: Colors.white)),
                title: const Text("Alex sent you a Friend Request"),
                subtitle: const Text("10 mins ago"),
                trailing: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.accept),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.emoji_events, color: Colors.white)),
                title: const Text("New Challenge: 100km Week!"),
                subtitle: const Text("Starts in 2 days"),
                trailing: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.view),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showProfileDialog(BuildContext context, dynamic profile) {
    showDialog(
      context: context,
      builder: (context) => ProfileDialog(profile: profile),
    );
  }

  void _showTrainingSettings(BuildContext context, dynamic profile) {
    if (profile != null) {
      TrainingDisplaySettingsSheet.show(context, profile);
    }
  }

  void _showSimConfig(BuildContext context) async {
    try {
      final cubit = context.read<TrainingCubit>();
      final result = await showDialog(
        context: context,
        builder: (context) =>
            SimulationConfigDialog(currentParams: cubit.state.simulationParams),
      );
      if (result != null) {
        cubit.updateSimulationParams(result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Simulation settings only available during training.')),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
