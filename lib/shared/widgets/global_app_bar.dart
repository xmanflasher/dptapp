import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const GlobalAppBar({
    super.key, 
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      leading: leading,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final profile = authState.user;
            if (profile == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 20, color: Colors.white),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                child: profile.avatarUrl == null ? Icon(Icons.person, size: 20, color: theme.primaryColor) : null,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
