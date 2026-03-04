import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_cubit.dart';
import '../resources/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade900, Colors.black],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_boat_filled, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              l10n.appTitle,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "PRO Dragon Boat Performance Tracking",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 80),
            _buildLoginButton(
              context,
              "Login via Mock Mode (Dev)",
              Icons.developer_mode,
              Colors.blueGrey,
              () => context.read<AuthCubit>().loginMock("Elite Paddler"),
            ),
            const SizedBox(height: 16),
            _buildLoginButton(
              context,
              "Login with Google",
              Icons.login,
              Colors.white.withOpacity(0.1),
              () => context.read<AuthCubit>().loginWithGoogle(),
            ),
            const SizedBox(height: 16),
            _buildLoginButton(
              context,
              "Login with Line",
              Icons.chat,
              Colors.green.withOpacity(0.3),
              () => context.read<AuthCubit>().loginWithLine(),
            ),
            const SizedBox(height: 16),
            _buildLoginButton(
              context,
              "Login with Facebook",
              Icons.facebook,
              Colors.blue.withOpacity(0.3),
              () => context.read<AuthCubit>().loginWithFacebook(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isComingSoon = false,
  }) {
    return SizedBox(
      width: 280,
      child: ElevatedButton.icon(
        onPressed: isComingSoon ? null : onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(isComingSoon ? "$label (Soon)" : label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}
