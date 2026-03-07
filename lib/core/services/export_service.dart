import 'package:dptapp/features/activities/domain/activities.dart';
import 'package:dptapp/features/training/domain/simulation_params.dart';

class ExportService {
  static String generateActivityCsv(Activity activity, SimulationParams params, double work, double power, double impulse) {
    final StringBuffer csv = StringBuffer();
    
    // Header
    csv.writeln('Dragon Boat Training Report');
    csv.writeln('Activity,${activity.title}');
    csv.writeln('Date,${activity.date}');
    csv.writeln('---');
    
    // Simulation Parameters
    csv.writeln('Simulation Parameters');
    csv.writeln('Wind Resistance,${params.windResistance}');
    csv.writeln('Water Resistance,${params.waterResistance}');
    csv.writeln('Boat Weight,${params.boatWeight}');
    csv.writeln('Crew Total Weight,${params.crewTotalWeight}');
    csv.writeln('---');
    
    // Outcomes
    csv.writeln('Calculated Outcomes');
    csv.writeln('Total Work (J),${work.toStringAsFixed(2)}');
    csv.writeln('Average Power (W),${power.toStringAsFixed(2)}');
    csv.writeln('Average Impulse (Ns),${impulse.toStringAsFixed(2)}');
    
    return csv.toString();
  }
}
