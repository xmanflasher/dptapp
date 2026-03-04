import 'package:flutter/material.dart';
import '../widgets/shell_navigation.dart';
import '../../presentation/resources/app_theme.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => ShellNavigation.shellScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Community'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(theme, 'Active Challenges'),
            const SizedBox(height: 12),
            _buildChallengeCard(
              theme,
              'Spring Sprint 5km',
              'Participants: 1,240',
              Icons.timer,
              Colors.orange,
              'Ends in 3 days',
            ),
            const SizedBox(height: 12),
            _buildChallengeCard(
              theme,
              'Cadence Master 90rpm',
              'Participants: 856',
              Icons.speed,
              Colors.blue,
              'Ends in 1 week',
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'World Leaderboard (500m)'),
            const SizedBox(height: 12),
            _buildLeaderboardItem(theme, 1, 'Elite_Paddler', '1:42.5', true),
            _buildLeaderboardItem(theme, 2, 'Dragon_Racer', '1:44.2', false),
            _buildLeaderboardItem(theme, 3, 'Water_Walker', '1:45.0', false),
            _buildLeaderboardItem(theme, 4, 'Stroke_King', '1:46.8', false),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChallengeCard(ThemeData theme, String title, String subtitle, IconData icon, Color color, String deadline) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: theme.hintColor, fontSize: 12)),
                ],
              ),
            ),
            Text(deadline, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(ThemeData theme, int rank, String name, String time, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? theme.primaryColor.withOpacity(0.1) : theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isMe ? theme.primaryColor : theme.dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('#$rank', style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=user')),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal))),
          Text(time, style: const TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
