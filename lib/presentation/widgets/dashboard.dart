import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothBloc, BluetoothState>(
      builder: (context, bluetoothState) {
        final isBluetoothConnected = bluetoothState is BluetoothConnected;

        return BlocBuilder<TimerBloc, TimerState>(
          builder: (context, timerState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Timer: ${timerState.duration}',
                  style: const TextStyle(fontSize: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isBluetoothConnected
                          ? () {
                              context.read<TimerBloc>().add(StartTimer());
                            }
                          : null,
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: isBluetoothConnected
                          ? () {
                              context.read<TimerBloc>().add(PauseTimer());
                            }
                          : null,
                      child: const Text('Pause'),
                    ),
                    ElevatedButton(
                      onPressed: isBluetoothConnected
                          ? () {
                              context.read<TimerBloc>().add(RecordLap());
                            }
                          : null,
                      child: const Text('Lap'),
                    ),
                    ElevatedButton(
                      onPressed: isBluetoothConnected
                          ? () {
                              context.read<TimerBloc>().add(StopTimer());
                            }
                          : null,
                      child: const Text('Stop'),
                    ),
                  ],
                ),
                if (timerState.laps.isNotEmpty)
                  Column(
                    children: timerState.laps
                        .map((lap) => Text('Lap: $lap'))
                        .toList(),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}