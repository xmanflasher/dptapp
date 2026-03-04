import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth_chart_cubit.dart';
import '../../../domain/service/bluetooth_service.dart';
import '../widgets/timer_widget.dart';
import '../widgets/navigation_drawer_widget.dart';
import '../bloc/auth/auth_cubit.dart';

class SyncrecordingPage extends StatelessWidget {
  const SyncrecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final profile = authState.user;
        final theme = Theme.of(context);

        return BlocProvider(
          create: (_) => BluetoothChartCubit(BluetoothService()),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Sync Recording",
                style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
              actions: [
                if (profile != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: profile.avatarUrl == null ? Icon(Icons.person, size: 20, color: theme.primaryColor) : null,
                    ),
                  ),
              ],
            ),
            drawer: const NavigationDrawerWidget(),
            body: const Center(child: TimerWidget()),
          ),
        );
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class SyncrecordingPage extends StatelessWidget {
  const SyncrecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Syncrecording'),
      ),
      body: BlocBuilder<BluetoothBloc, BluetoothState>(
        builder: (context, state) {
          if (state is BluetoothInitial || state is BluetoothOn) {
            return const Dashboard();
          } else if (state is BluetoothScanning) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BluetoothConnected) {
            return const Dashboard();
          } else if (state is BluetoothDataReceived) {
            return const Dashboard();
          } else if (state is BluetoothOff) {
            return Container(
              color: Colors.grey.withOpacity(0.5),
              child: const Center(
                child: Text(
                  'Bluetooth is Off',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
*/
