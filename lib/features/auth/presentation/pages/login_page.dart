import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:dptapp/core/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login Failed: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0D0D0D),
                      Colors.deepPurple.shade900.withValues(alpha: 0.8),
                      const Color(0xFF000000),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 1),
                          builder: (context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withValues(alpha: 0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_boat_filled,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                l10n.appTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "PRO DRAGON BOAT PERFORMANCE",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        _buildLoginButton(
                          context,
                          "Login via Mock Mode (Dev)",
                          Icons.developer_mode,
                          Colors.blueGrey.withValues(alpha: 0.2),
                          () => context.read<AuthCubit>().loginMock("Elite Paddler"),
                        ),
                        const SizedBox(height: 16),
                        _buildLoginButton(
                          context,
                          "Login with Google",
                          Icons.g_mobiledata,
                          Colors.white.withValues(alpha: 0.1),
                          () => context.read<AuthCubit>().loginWithGoogle(),
                        ),
                        const SizedBox(height: 16),
                        _buildLoginButton(
                          context,
                          "Login with Line",
                          Icons.chat_bubble_outline,
                          const Color(0xFF00B900).withValues(alpha: 0.2),
                          () => context.read<AuthCubit>().loginWithLine(),
                        ),
                        const SizedBox(height: 16),
                        _buildLoginButton(
                          context,
                          "Login with Facebook",
                          Icons.facebook_outlined,
                          const Color(0xFF1877F2).withValues(alpha: 0.2),
                          () => context.read<AuthCubit>().loginWithFacebook(),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "By continuing, you agree to our Terms of Service",
                          style: TextStyle(color: Colors.white24, fontSize: 10),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.status == AuthStatus.authenticating)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
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
