import 'package:flutter/material.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveHUD extends StatelessWidget {
  final double speed;
  final double cadence;
  final double power;
  final double work;
  final double impulse;
  final double targetPower;
  final List<String> visibleMetrics;
  final bool isSyncing;
  final String? sessionTitle;

  const LiveHUD({
    super.key,
    required this.speed,
    required this.cadence,
    required this.power,
    required this.work,
    required this.impulse,
    this.targetPower = 200.0,
    this.visibleMetrics = const [
      'speed',
      'cadence',
      'power',
      'work',
      'impulse',
      'sync'
    ],
    this.isSyncing = false,
    this.sessionTitle,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark
        ? Colors.black.withValues(alpha: 0.9)
        : Colors.white;
    final labelColor = isDark ? Colors.white70 : Colors.black54;
    final valueColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: powerColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: powerColor.withValues(alpha: isDark ? 0.4 : 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (visibleMetrics.contains('sync'))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  if (sessionTitle != null && sessionTitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        sessionTitle!,
                        style: TextStyle(
                          color: valueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sync,
                        size: 16,
                        color: isSyncing ? AppTheme.primaryBlue : labelColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSyncing ? "RECORDING & SYNCING" : "RECORDS SYNCED",
                        style: TextStyle(
                          color: isSyncing ? AppTheme.primaryBlue : labelColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (visibleMetrics.contains('speed'))
            _buildMainMetric(
              l10n.speed.toUpperCase(),
              speed.toStringAsFixed(1),
              'km/h',
              isDark ? AppTheme.primaryBlue : Colors.blue.shade700,
              isDark,
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (visibleMetrics.contains('cadence'))
                _buildSecondaryMetric(
                  l10n.cadence.toUpperCase(),
                  cadence.toInt().toString(),
                  'BPM',
                  labelColor: labelColor,
                  valueColor: valueColor,
                ),
              if (visibleMetrics.contains('power'))
                _buildSecondaryMetric(
                  l10n.power.toUpperCase(),
                  power.toInt().toString(),
                  'W',
                  color: powerColor,
                  labelColor: labelColor,
                  valueColor: powerColor,
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (visibleMetrics.contains('work') || visibleMetrics.contains('impulse'))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (visibleMetrics.contains('work'))
                  _buildSecondaryMetric(
                    l10n.work.toUpperCase(),
                    (work / 1000).toStringAsFixed(1),
                    'kJ',
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
                if (visibleMetrics.contains('impulse'))
                  _buildSecondaryMetric(
                    l10n.impulse.toUpperCase(),
                    impulse.toStringAsFixed(1),
                    'Ns',
                    labelColor: labelColor,
                    valueColor: valueColor,
                  ),
              ],
            ),
          const SizedBox(height: 24),
          _buildTargetIndicator(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildMainMetric(
      String label, String value, String unit, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? color.withValues(alpha: 0.9) : color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : color,
                fontSize: 72,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              unit,
              style: TextStyle(
                color: isDark ? Colors.white70 : color.withValues(alpha: 0.7),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryMetric(
    String label,
    String value,
    String unit, {
    Color? color,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color ?? valueColor,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetIndicator(AppLocalizations l10n, bool isDark) {
    double progress = (power / targetPower).clamp(0.0, 1.2);
    final indicatorColor = _getPowerColor(power);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TARGET: ${targetPower.toInt()}W',
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black45,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: indicatorColor,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor: isDark ? Colors.white12 : Colors.grey.shade300,
            color: indicatorColor,
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
