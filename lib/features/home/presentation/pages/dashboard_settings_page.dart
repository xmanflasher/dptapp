import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dptapp/features/auth/domain/user_profile.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';

class DashboardSettingsPage extends StatefulWidget {
  final UserProfile profile;

  const DashboardSettingsPage({super.key, required this.profile});

  @override
  State<DashboardSettingsPage> createState() => _DashboardSettingsPageState();
}

class _DashboardSettingsPageState extends State<DashboardSettingsPage> {
  late List<String> _visibleLayout;
  late List<String> _hiddenLayout;

  Map<String, String> _getModuleNames(AppLocalizations l10n) {
    return {
      'cycle_progress': l10n.cycleProgressTitle,
      'daily_stats': l10n.dailyStats,
      'achievements': l10n.achievementsTitle,
      'quick_start': l10n.quickStartTitle,
    };
  }

  @override
  void initState() {
    super.initState();
    final prefs = widget.profile.preferences['home_dashboard_layout'];
    if (prefs != null && prefs is List) {
      _visibleLayout = List<String>.from(prefs);
    } else {
      _visibleLayout = [
        'cycle_progress',
        'daily_stats',
        'achievements',
        'quick_start'
      ];
    }

    _hiddenLayout = [];
    final moduleKeys = ['cycle_progress', 'daily_stats', 'achievements', 'quick_start'];
    for (var key in moduleKeys) {
      if (!_visibleLayout.contains(key)) {
        _hiddenLayout.add(key);
      }
    }
  }

  void _saveAndClose() {
    final updatedPrefs = Map<String, dynamic>.from(widget.profile.preferences);
    updatedPrefs['home_dashboard_layout'] =
        _visibleLayout; // Only save visible items

    final updatedProfile = widget.profile.copyWith(preferences: updatedPrefs);
    context.read<AuthCubit>().updateProfile(updatedProfile);
    Navigator.of(context).pop();
  }

  Widget _buildListTile(BuildContext context, String key, bool isVisible) {
    final l10n = AppLocalizations.of(context)!;
    final moduleNames = _getModuleNames(l10n);
    return Card(
      key: ValueKey(key),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: isVisible ? Theme.of(context).primaryColor : Colors.grey,
        ),
        title: Text(
          moduleNames[key] ?? key,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isVisible ? null : Colors.grey,
          ),
        ),
        trailing: isVisible
            ? const Icon(Icons.drag_handle)
            : TextButton(
                onPressed: () {
                  setState(() {
                    _hiddenLayout.remove(key);
                    _visibleLayout.add(key);
                  });
                },
                child: Text(l10n.add),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(l10n.customizeDashboard, style: const TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.dashboardSettingsHint,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _visibleLayout.removeAt(oldIndex);
                  _visibleLayout.insert(newIndex, item);
                });
              },
              children: [
                for (int index = 0; index < _visibleLayout.length; index++)
                  Container(
                    key: ValueKey('container_${_visibleLayout[index]}'),
                    child: Dismissible(
                      key: ValueKey('dismiss_${_visibleLayout[index]}'),
                      direction: DismissDirection.endToStart,
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.3,
                      },
                      dragStartBehavior: DragStartBehavior.down,
                      background: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(l10n.hide, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Icon(Icons.visibility_off, color: Colors.white),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        setState(() {
                          final removed = _visibleLayout.removeAt(index);
                          _hiddenLayout.add(removed);
                        });
                      },
                      child: ReorderableDragStartListener(
                        key: ValueKey('drag_${_visibleLayout[index]}'),
                        index: index,
                        child: _buildListTile(context, _visibleLayout[index], true),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_hiddenLayout.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.hiddenModules,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  for (var key in _hiddenLayout) _buildListTile(context, key, false),
                ],
              ),
            ),
          ],
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndClose,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.saveLayout,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
