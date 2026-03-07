import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/training/presentation/bloc/training_state.dart';
import 'package:dptapp/core/parsers/physics_engine.dart';
import 'package:dptapp/features/training/domain/simulation_params.dart';

class TrainingCubit extends Cubit<TrainingState> {
  Timer? _mockTimer;

  TrainingCubit() : super(const TrainingState());

  @override
  Future<void> close() {
    _mockTimer?.cancel();
    return super.close();
  }

  void updateSimulationParams(SimulationParams params) {
    emit(state.copyWith(simulationParams: params));
  }

  void updateTargetPower(double target) {
    emit(state.copyWith(targetPower: target));
  }

  void onDataReceived({
    required double newSpeedMs,
    required double newCadenceBpm,
    required double timeDeltaSeconds,
  }) {
    final metrics = PhysicsEngine.calculate(
      currentSpeed: newSpeedMs,
      previousSpeed: state.speed,
      timeDelta: timeDeltaSeconds,
      cadence: newCadenceBpm,
      params: state.simulationParams,
    );

    emit(state.copyWith(
      speed: newSpeedMs,
      cadence: newCadenceBpm,
      power: metrics.power,
      work: state.work + metrics.work,
      impulse: metrics.impulse,
    ));
  }

  void startRecording() {
    emit(state.copyWith(isRecording: true, work: 0.0));
    
    // Start generating mock data for visualization
    _mockTimer?.cancel();
    _mockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isRecording) {
        timer.cancel();
        return;
      }
      
      // Mock some variation
      final mockSpeed = 3.0 + (timer.tick % 5) * 0.2; // 3.0 to 4.0 m/s
      final mockCadence = 60.0 + (timer.tick % 10); // 60 to 70 BPM
      
      onDataReceived(
        newSpeedMs: mockSpeed,
        newCadenceBpm: mockCadence,
        timeDeltaSeconds: 1.0,
      );
    });
  }

  void stopRecording() {
    _mockTimer?.cancel();
    emit(state.copyWith(isRecording: false));
  }

  void reset() {
    _mockTimer?.cancel();
    emit(const TrainingState());
  }
}
