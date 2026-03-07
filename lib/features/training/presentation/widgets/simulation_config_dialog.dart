import 'package:flutter/material.dart';
import 'package:dptapp/features/training/domain/simulation_params.dart';

class SimulationConfigDialog extends StatefulWidget {
  final SimulationParams currentParams;

  const SimulationConfigDialog({super.key, required this.currentParams});

  @override
  State<SimulationConfigDialog> createState() => _SimulationConfigDialogState();
}

class _SimulationConfigDialogState extends State<SimulationConfigDialog> {
  late double wind;
  late double water;
  late double boatWeight;
  late double crewWeight;

  @override
  void initState() {
    super.initState();
    wind = widget.currentParams.windResistance;
    water = widget.currentParams.waterResistance;
    boatWeight = widget.currentParams.boatWeight;
    crewWeight = widget.currentParams.crewTotalWeight;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Simulation Parameters'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildSlider('Wind Resistance', wind, 0, 10, (v) => setState(() => wind = v)),
            _buildSlider('Water Resistance', water, 0, 10, (v) => setState(() => water = v)),
            _buildSlider('Boat Weight (kg)', boatWeight, 100, 1000, (v) => setState(() => boatWeight = v)),
            _buildSlider('Crew Total Weight (kg)', crewWeight, 0, 2000, (v) => setState(() => crewWeight = v)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              SimulationParams(
                windResistance: wind,
                waterResistance: water,
                boatWeight: boatWeight,
                crewTotalWeight: crewWeight,
              ),
            );
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
