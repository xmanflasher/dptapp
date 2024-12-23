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
