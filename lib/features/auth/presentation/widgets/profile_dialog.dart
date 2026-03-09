import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/domain/user_profile.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';

class ProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const ProfileDialog({super.key, required this.profile});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late TextEditingController _nameController;
  late String? _selectedAvatarUrl;

  final List<String> _avatarOptions = [
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Dragon',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Paddler',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Racer',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Champion',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=Hero',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _selectedAvatarUrl = widget.profile.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    final updatedProfile = widget.profile.copyWith(
      displayName: newName,
      avatarUrl: _selectedAvatarUrl,
    );

    context.read<AuthCubit>().updateProfile(updatedProfile);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editProfile),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.enterNameHint,
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.chooseAvatar,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedAvatarUrl = null),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: _selectedAvatarUrl == null
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    child: Icon(Icons.person,
                        color: _selectedAvatarUrl == null
                            ? Colors.white
                            : Colors.grey),
                  ),
                ),
                ..._avatarOptions
                    .map((url) => GestureDetector(
                          onTap: () => setState(() => _selectedAvatarUrl = url),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedAvatarUrl == url
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(url),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _saveProfile,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
