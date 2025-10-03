import 'package:flutter/material.dart';

class DataDisplayCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const DataDisplayCard({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardColor;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
    );
    final valueStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(icon, color: theme.iconTheme.color)
            else
              const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: labelStyle),
                  const SizedBox(height: 4),
                  Text(value, style: valueStyle, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
