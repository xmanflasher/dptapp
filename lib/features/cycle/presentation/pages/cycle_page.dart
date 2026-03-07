import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/core/routers/app_routes.dart';

class CyclePage extends StatelessWidget {
  const CyclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Cycle'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.loop, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Cycle Generator\nComing Soon in Phase 6',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.go('${AppRoutes.cycle}/activities');
              },
              icon: const Icon(Icons.history),
              label: const Text('View Activity History'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
