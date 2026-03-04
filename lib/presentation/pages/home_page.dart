import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/widgets.dart';
import '../widgets/shell_navigation.dart';
import '../widgets/badge_card.dart';
import '../../core/routers/app_routes.dart';
import '../resources/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/auth/auth_cubit.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final profile = authState.user;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => ShellNavigation.shellScaffoldKey.currentState?.openDrawer(),
            ),
            title: Text(
              l10n.appTitle,
              style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            actions: [
              if (profile != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                    backgroundColor: theme.primaryColor.withOpacity(0.2),
                    child: profile.avatarUrl == null ? Icon(Icons.person, size: 20, color: theme.primaryColor) : null,
                  ),
                ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile != null && profile.earnedBadges.isNotEmpty) ...[
                        _buildSectionHeader("My Badges"),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: profile.earnedBadges.length,
                            itemBuilder: (context, index) => BadgeCard(badge: profile.earnedBadges[index]),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      _buildSectionHeader(l10n.training),
                      const SizedBox(height: 12),
                      _buildQuickAction(
                        context,
                        l10n.startSession,
                        Icons.play_circle_fill,
                        AppTheme.primaryBlue,
                        () => context.go(AppRoutes.training),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader(l10n.activities),
                      const SizedBox(height: 12),
                      _buildSummaryGrid(l10n),
                      const SizedBox(height: 24),
                      _buildRecentActivity(l10n, theme, context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildSummaryCard(l10n.distance, "42.5", "km", AppTheme.batteryBlue, Icons.straighten),
        _buildSummaryCard(l10n.power, "185", "W", AppTheme.primaryBlue, Icons.bolt),
        _buildSummaryCard(l10n.calories, "1,240", "kcal", AppTheme.loadOrange, Icons.local_fire_department),
        _buildSummaryCard("HEART RATE", "68", "bpm", AppTheme.hrRed, Icons.favorite),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, String unit, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              Text(unit, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(AppLocalizations l10n, ThemeData theme, BuildContext context) {
    return InkWell(
      onTap: () => context.go(AppRoutes.activities),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.activities, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text("2024-09-04", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Dragon Boat Intervals - 10km", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniMetric("AVG PWR", "210W"),
                _buildMiniMetric("DIST", "10.2km"),
                _buildMiniMetric("TIME", "48:27"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}