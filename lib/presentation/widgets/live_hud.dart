import 'package:flutter/material.dart';
import '../resources/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveHUD extends StatelessWidget {
  final double speed;
  final double cadence;
  final double power;
  final double work;
  final double impulse;
  final double targetPower;

  const LiveHUD({
    super.key,
    required this.speed,
    required this.cadence,
    required this.power,
    required this.work,
    required this.impulse,
    this.targetPower = 200.0,
  });

  Color _getPowerColor(double currentPower) {
    if (currentPower < 100) return AppTheme.greenStatus;
    if (currentPower < 150) return AppTheme.batteryBlue;
    if (currentPower < 200) return AppTheme.primaryBlue;
    if (currentPower < 250) return AppTheme.loadOrange;
    return AppTheme.hrRed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final powerColor = _getPowerColor(power);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: powerColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMainMetric(l10n.speed.toUpperCase(), speed.toStringAsFixed(1), 'km/h', Colors.blue),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSecondaryMetric(l10n.cadence.toUpperCase(), cadence.toInt().toString(), 'BPM'),
              _buildSecondaryMetric(l10n.power.toUpperCase(), power.toInt().toString(), 'W', color: powerColor),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSecondaryMetric(l10n.work.toUpperCase(), (work / 1000).toStringAsFixed(1), 'kJ'),
              _buildSecondaryMetric(l10n.impulse.toUpperCase(), impulse.toStringAsFixed(1), 'Ns'),
            ],
          ),
          const SizedBox(height: 20),
          _buildTargetIndicator(l10n),
        ],
      ),
    );
  }

  Widget _buildMainMetric(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 64, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Text(unit, style: TextStyle(color: color.withOpacity(0.7), fontSize: 20)),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryMetric(String label, String value, String unit, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text(unit, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetIndicator(AppLocalizations l10n) {
    double progress = (power / targetPower).clamp(0.0, 1.2);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TARGET: ${targetPower.toInt()}W', style: const TextStyle(color: Colors.white54, fontSize: 10)),
            Text('${(progress * 100).toInt()}%', style: TextStyle(color: _getPowerColor(power), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress > 1.0 ? 1.0 : progress,
          backgroundColor: Colors.white12,
          color: _getPowerColor(power),
          minHeight: 8,
        ),
      ],
    );
  }
}
