import 'package:flutter/material.dart';

class PremiumOverlay extends StatelessWidget {
  final Widget child;
  final bool isLocked;
  final String featureName;

  const PremiumOverlay({
    super.key,
    required this.child,
    required this.isLocked,
    this.featureName = 'This feature',
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return child;
    }

    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        // Blur or dim the underlying child
        Opacity(
          opacity: 0.4,
          child: child,
        ),

        // Intercept taps
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showUpgradeDialog(context),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.shade700, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline,
                          color: Colors.amber.shade700, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "PRO",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber.shade700),
            const SizedBox(width: 8),
            const Text("Elite Dragon Status"),
          ],
        ),
        content: Text(
            "$featureName is an advanced feature reserved for Premium users. Upgrade to unlock powerful analytics and AI cycle generation."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Not Now"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Route to IAP purchase screen in Phase 9
            },
            child: const Text("Upgrade Now"),
          ),
        ],
      ),
    );
  }
}
