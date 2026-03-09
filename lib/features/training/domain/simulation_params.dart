import 'package:equatable/equatable.dart';

class SimulationParams extends Equatable {
  final double windResistance; // N or a coefficient
  final double waterResistance; // N or a coefficient
  final double boatWeight; // kg
  final double crewTotalWeight; // kg
  final List<double>
      crewDistribution; // Weights per seat or a center of gravity offset

  const SimulationParams({
    this.windResistance = 0.0,
    this.waterResistance = 0.0,
    this.boatWeight = 300.0,
    this.crewTotalWeight = 0.0,
    this.crewDistribution = const [],
  });

  SimulationParams copyWith({
    double? windResistance,
    double? waterResistance,
    double? boatWeight,
    double? crewTotalWeight,
    List<double>? crewDistribution,
  }) {
    return SimulationParams(
      windResistance: windResistance ?? this.windResistance,
      waterResistance: waterResistance ?? this.waterResistance,
      boatWeight: boatWeight ?? this.boatWeight,
      crewTotalWeight: crewTotalWeight ?? this.crewTotalWeight,
      crewDistribution: crewDistribution ?? this.crewDistribution,
    );
  }

  double get totalMass => boatWeight + crewTotalWeight;

  @override
  List<Object?> get props => [
        windResistance,
        waterResistance,
        boatWeight,
        crewTotalWeight,
        crewDistribution,
      ];

  Map<String, dynamic> toMap() {
    return {
      'windResistance': windResistance,
      'waterResistance': waterResistance,
      'boatWeight': boatWeight,
      'crewTotalWeight': crewTotalWeight,
      'crewDistribution': crewDistribution,
    };
  }

  factory SimulationParams.fromMap(Map<String, dynamic> map) {
    return SimulationParams(
      windResistance: (map['windResistance'] as num?)?.toDouble() ?? 0.0,
      waterResistance: (map['waterResistance'] as num?)?.toDouble() ?? 0.0,
      boatWeight: (map['boatWeight'] as num?)?.toDouble() ?? 300.0,
      crewTotalWeight: (map['crewTotalWeight'] as num?)?.toDouble() ?? 0.0,
      crewDistribution: List<double>.from(map['crewDistribution'] ?? []),
    );
  }
}
