import 'dart:math';
import 'package:dptapp/features/training/domain/simulation_params.dart';

class PerformanceMetrics {
  final double work; // Joules
  final double power; // Watts
  final double impulse; // N*s (for a stroke)

  PerformanceMetrics({
    required this.work,
    required this.power,
    required this.impulse,
  });
}

class PhysicsEngine {
  /// Calculates real-time performance metrics.
  /// 
  /// [currentSpeed] is in m/s.
  /// [previousSpeed] is in m/s (used for acceleration calculation).
  /// [timeDelta] is the time between samples in seconds.
  /// [cadence] is strokes per minute (BPM).
  static PerformanceMetrics calculate({
    required double currentSpeed,
    required double previousSpeed,
    required double timeDelta,
    required double cadence,
    required SimulationParams params,
  }) {
    if (timeDelta <= 0) return PerformanceMetrics(work: 0, power: 0, impulse: 0);

    // 1. Total Mass (Boat + Crew)
    final double mass = params.totalMass;

    // 2. Acceleration (a = dv / dt)
    final double acceleration = (currentSpeed - previousSpeed) / timeDelta;

    // 3. Resistive Forces (Simplified Model)
    // Drag = (k_wind + k_water) * v^2
    // We assume params coefficients are applied to v^2 or v depending on the simplified model
    final double drag = (params.windResistance + params.waterResistance) * pow(currentSpeed, 2);

    // 4. Net Force required (F = m*a + drag)
    final double force = (mass * acceleration) + drag;

    // 5. Instantaneous Power (P = F * v)
    final double power = max(0.0, force * currentSpeed);

    // 6. Work (W = P * dt)
    final double work = power * timeDelta;

    // 7. Impulse per stroke (Simplified)
    // Impulse = Force * (Stroke Duration)
    // Stroke Duration (seconds) = 60 / Cadence
    double impulse = 0.0;
    if (cadence > 0) {
      final double strokeDuration = 60 / cadence;
      impulse = force * strokeDuration;
    }

    return PerformanceMetrics(
      work: work,
      power: power,
      impulse: impulse,
    );
  }

  /// Calculates the cumulative metrics for an entire activity session.
  /// This can be used for summary statistics.
  static Map<String, double> calculateSummary({
    required double totalDistance,
    required Duration totalTime,
    required double avgCadence,
    required SimulationParams params,
  }) {
    // Very simplified summary calculation
    final double avgSpeed = totalDistance / (totalTime.inSeconds > 0 ? totalTime.inSeconds : 1);
    final double drag = (params.windResistance + params.waterResistance) * pow(avgSpeed, 2);
    final double avgForce = drag; // Assuming net acceleration is 0 over long term
    
    final double totalWork = avgForce * totalDistance;
    final double avgPower = avgForce * avgSpeed;
    
    // Impulse per stroke average
    final double strokeDuration = avgCadence > 0 ? 60 / avgCadence : 0;
    final double avgImpulse = avgForce * strokeDuration;

    return {
      'totalWork': totalWork,
      'averagePower': avgPower,
      'avgImpulse': avgImpulse,
    };
  }
}
