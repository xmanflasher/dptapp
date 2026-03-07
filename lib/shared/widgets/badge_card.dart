import 'package:flutter/material.dart' hide Badge;
import 'package:dptapp/features/auth/domain/badge.dart';

class BadgeCard extends StatelessWidget {
  final Badge badge;

  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber.shade100,
            child: Icon(_getIconData(badge.iconAsset), color: Colors.amber.shade800),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String asset) {
    switch (asset) {
      case 'bolt': return Icons.bolt;
      case 'wb_sunny': return Icons.wb_sunny;
      default: return Icons.stars;
    }
  }
}
