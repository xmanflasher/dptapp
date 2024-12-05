import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Setting'),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),ListTile(
              title: Text('Record'),
              onTap: () {
                Navigator.pushNamed(context, '/record');
              },
            ),
            ListTile(
              title: Text('Receive'),
              onTap: () {
                Navigator.pushNamed(context, '/receive');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/record');
          },
          child: const Text('Go to Record Page'),
        ),
      ),
    );
  }
}
