import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bluetooth/bluetooth_bloc.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<BluetoothBloc, BluetoothState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<BluetoothBloc>().add(TurnOnBluetooth());
                  },
                  child: const Text('Turn On Bluetooth'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<BluetoothBloc>().add(TurnOffBluetooth());
                  },
                  child: const Text('Turn Off Bluetooth'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<BluetoothBloc>().add(StartScan());
                  },
                  child: const Text('Start Scan'),
                ),
                if (state is BluetoothOn) ...[
                  const Text('Bluetooth is On'),
                ] else if (state is BluetoothOff) ...[
                  const Text('Bluetooth is Off'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
