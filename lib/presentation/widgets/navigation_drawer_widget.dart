import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              context.go('/settings');
            },
          ),
          ListTile(
            title: const Text('Records'),
            onTap: () {
              context.go('/records');
            },
          ),
          ListTile(
            title: const Text('Detail'),
            onTap: () {
              context.go('/detail');
            },
          ),
          ListTile(
            title: const Text('Syncrecording'),
            onTap: () {
              context.go('/syncrecording');
            },
          ),
        ],
      ),
    );
  }
}
