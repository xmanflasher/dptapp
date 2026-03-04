import 'package:equatable/equatable.dart';
import '../../../domain/entities/simulation_params.dart';
import '../../../core/parsers/physics_engine.dart';

class TrainingState extends Equatable {
  final double speed; // m/s
  final double cadence; // BPM
  final double power; // Watts
  final double work; // Joules
  final double impulse; // N*s
  final SimulationParams simulationParams;
  final double targetPower;
  final bool isRecording;

  const TrainingState({
    this.speed = 0.0,
    this.cadence = 0.0,
    this.power = 0.0,
    this.work = 0.0,
    this.impulse = 0.0,
    this.simulationParams = const SimulationParams(),
    this.targetPower = 200.0, // Default target
    this.isRecording = false,
  });

  TrainingState copyWith({
    double? speed,
    double? cadence,
    double? power,
    double? work,
    double? impulse,
    SimulationParams? simulationParams,
    double? targetPower,
    bool? isRecording,
  }) {
    return TrainingState(
      speed: speed ?? this.speed,
      cadence: cadence ?? this.cadence,
      power: power ?? this.power,
      work: work ?? this.work,
      impulse: impulse ?? this.impulse,
      simulationParams: simulationParams ?? this.simulationParams,
      targetPower: targetPower ?? this.targetPower,
      isRecording: isRecording ?? this.isRecording,
    );
  }

  @override
  List<Object?> get props => [
        speed,
        cadence,
        power,
        work,
        impulse,
        simulationParams,
        targetPower,
        isRecording,
      ];
}
