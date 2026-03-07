import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/training/domain/training_menu.dart';

class AssessmentResult {
  final double qualityScore; // 0.0 to 1.0
  final List<String> feedback;
  final bool targetsMet;

  AssessmentResult({
    required this.qualityScore,
    required this.feedback,
    required this.targetsMet,
  });
}

class TrainingAssessor {
  /// Assesses an activity against a training menu.
  static AssessmentResult assess({
    required Activity activity,
    required TrainingMenu menu,
  }) {
    List<String> feedback = [];
    bool targetsMet = true;
    double score = 1.0;

    // 1. Check Power Target
    if (menu.targetPower != null && menu.targetPower! > 0) {
      final double powerRatio = activity.averagePower / menu.targetPower!;
      if (powerRatio < 0.9) {
        feedback.add("Average power was ${(100 - powerRatio * 100).toInt()}% below target.");
        targetsMet = false;
        score -= (0.9 - powerRatio);
      } else if (powerRatio > 1.1) {
        feedback.add("Excellent intensity! You exceeded the power target by ${(powerRatio * 100 - 100).toInt()}%.");
      } else {
        feedback.add("On target for power intensity.");
      }
    }

    // 2. Check Cadence Target
    if (menu.targetCadence != null && menu.targetCadence! > 0) {
      final double cadenceDiff = (activity.averageCadence - menu.targetCadence!).abs().toDouble();
      if (cadenceDiff > 5) {
        feedback.add("Cadence was off by ${cadenceDiff.toInt()} BPM. Focus on the set rhythm.");
        targetsMet = false;
        score -= (cadenceDiff / 40); // Penalty
      } else {
        feedback.add("Stable cadence maintained.");
      }
    }

    // 3. Check Work/Volume
    if (menu.expectedDistance != null && menu.expectedDistance! > 0) {
      final double distanceRatio = activity.distance / menu.expectedDistance!;
      if (distanceRatio < 0.95) {
        feedback.add("Volume was low. You completed ${(distanceRatio * 100).toInt()}% of the target distance.");
        targetsMet = false;
        score -= 0.1;
      }
    }

    return AssessmentResult(
      qualityScore: score.clamp(0.0, 1.0),
      feedback: feedback,
      targetsMet: targetsMet,
    );
  }
}
