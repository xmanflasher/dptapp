import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/training/presentation/bloc/training_cubit.dart';
import 'package:dptapp/features/training/presentation/bloc/training_state.dart';
import 'package:dptapp/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:dptapp/features/training/presentation/widgets/live_hud.dart';
import 'package:dptapp/features/training/presentation/widgets/simulation_config_dialog.dart';
import 'package:dptapp/shared/widgets/global_app_bar.dart';
import 'package:dptapp/shared/widgets/shell_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/core/routers/app_routes.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingCubit(),
      child: const _TrainingView(),
    );
  }
}

class _TrainingView extends StatelessWidget {
  const _TrainingView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final profile = authState.user;
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: GlobalAppBar(
            title: l10n.training,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => ShellNavigation.shellScaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_input_component),
                onPressed: () => _showSimConfig(context),
              ),
            ],
          ),
          body: BlocBuilder<TrainingCubit, TrainingState>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              final double targetPower = settings.powerZones['Z3']?.toDouble() ?? 200.0;

              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: LiveHUD(
                        speed: state.speed,
                        cadence: state.cadence,
                        power: state.power,
                        work: state.work,
                        impulse: state.impulse,
                        targetPower: targetPower,
                      ),
                    ),
                  ),
                  _buildRecordingControls(context, state, l10n),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showSimConfig(BuildContext context) async {
    final currentParams = context.read<TrainingCubit>().state.simulationParams;
    final result = await showDialog(
      context: context,
      builder: (context) => SimulationConfigDialog(currentParams: currentParams),
    );
    if (result != null) {
      context.read<TrainingCubit>().updateSimulationParams(result);
    }
  }

  Widget _buildRecordingControls(BuildContext context, TrainingState state, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (state.isRecording) {
                context.read<TrainingCubit>().stopRecording();
              } else {
                context.read<TrainingCubit>().startRecording();
              }
            },
            icon: Icon(state.isRecording ? Icons.stop : Icons.play_arrow),
            label: Text(state.isRecording ? l10n.stopSession : l10n.startSession),
            style: ElevatedButton.styleFrom(
              backgroundColor: state.isRecording ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () => context.read<TrainingCubit>().reset(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Stats',
          ),
        ],
      ),
    );
  }
}
