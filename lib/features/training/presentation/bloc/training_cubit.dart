import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
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

    final updatedPoints = List<FlSpot>.from(state.performancePoints);
    final nextX = updatedPoints.isEmpty ? 0.0 : updatedPoints.last.x + 1;
    // We display km/h in the chart, so convert m/s to km/h
    updatedPoints.add(FlSpot(nextX, newSpeedMs * 3.6));
    
    // Limit points to prevent memory issues (e.g., last 100 points)
    if (updatedPoints.length > 100) {
      updatedPoints.removeAt(0);
    }

    emit(state.copyWith(
      speed: newSpeedMs,
      cadence: newCadenceBpm,
      power: metrics.power,
      work: state.work + metrics.work,
      impulse: metrics.impulse,
      performancePoints: updatedPoints,
    ));
  }

  void startRecording() {
    emit(state.copyWith(
      isRecording: true,
      work: 0.0,
      performancePoints: [],
      sessionTitle: "內湖區 骑行",
    ));

    // Start generating mock data for visualization
    _mockTimer?.cancel();
    _mockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isRecording) {
        timer.cancel();
        return;
      }

      // 18.61 km/h = 5.1694 m/s
      // Mock some variation around 5.17 m/s
      final variability = (timer.tick % 5 - 2) * 0.05; // -0.1 to 0.1 m/s shift
      final mockSpeed = 5.1694 + variability;
      final mockCadence = 68.0 + (timer.tick % 5);

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
