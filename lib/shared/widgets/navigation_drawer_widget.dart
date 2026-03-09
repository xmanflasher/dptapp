import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:dptapp/core/routers/app_routes.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/theme/app_theme.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<BluetoothBloc>().add(CheckBluetoothStatus());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
      elevation: 0,
      width: 280,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? [AppTheme.surface, const Color(0xFF121212)] 
                  : [AppTheme.primaryBlue, AppTheme.primaryBlue.withValues(alpha: 0.8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.flash_on, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(
            icon: Icons.settings_outlined,
            title: l10n.settings,
            onTap: () => context.go(AppRoutes.settings),
          ),
          _buildItem(
            icon: Icons.sync,
            title: l10n.syncrecording,
            subtitle: "Manage training data",
            onTap: () => context.go(AppRoutes.syncrecording),
          ),
          const Spacer(),
          const Divider(indent: 24, endIndent: 24, height: 1),
          _buildItem(
            icon: Icons.logout,
            title: 'Logout',
            color: Colors.redAccent,
            onTap: () => context.read<AuthCubit>().logout(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: color ?? (isDark ? Colors.white70 : Colors.black87)),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }
}
