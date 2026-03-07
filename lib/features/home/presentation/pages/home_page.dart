import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/shared/widgets/widgets.dart';
import 'package:dptapp/core/routers/app_routes.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';

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
          appBar: GlobalAppBar(
            title: l10n.appTitle,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => ShellNavigation.shellScaffoldKey.currentState?.openDrawer(),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MY DAY",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Primary Cycle Progress Card
                        const CycleProgressCard(
                          phaseName: "Specific Conversion",
                          progress: 0.65,
                          weekInfo: "Week 3 of 4 (Intense)",
                          nextSession: "Intervals: 90% x 500m x 8",
                        ),
                        const SizedBox(height: 24),
                        
                        _buildSectionHeader("DAILY STATS"),
                        const SizedBox(height: 12),
                        _buildSummaryGrid(context, l10n),
                        const SizedBox(height: 24),

                        if (profile != null && profile.earnedBadges.isNotEmpty) ...[
                          _buildSectionHeader("LATEST ACHIEVEMENTS"),
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

                        _buildSectionHeader("QUICK START"),
                        const SizedBox(height: 12),
                        _buildQuickAction(
                          context,
                          l10n.startSession,
                          Icons.play_circle_fill,
                          AppTheme.primaryBlue,
                          () => context.go(AppRoutes.training),
                        ),
                        const SizedBox(height: 40), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
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

  Widget _buildSummaryGrid(BuildContext context, AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildSummaryCard(context, l10n.distance, "42.5", "km", AppTheme.batteryBlue, Icons.straighten),
        _buildSummaryCard(context, l10n.power, "185", "W", AppTheme.primaryBlue, Icons.bolt),
        _buildSummaryCard(context, l10n.calories, "1,240", "kcal", AppTheme.loadOrange, Icons.local_fire_department),
        _buildSummaryCard(context, "HEART RATE", "68", "bpm", AppTheme.hrRed, Icons.favorite),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String label, String value, String unit, Color color, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                label, 
                style: TextStyle(
                  fontSize: 11, 
                  color: isDark ? Colors.grey : Colors.grey.shade600, 
                  fontWeight: FontWeight.w500
                )
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              Text(unit, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey : Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}