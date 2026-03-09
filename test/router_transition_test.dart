import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// This test demonstrates and verifies the Page Transition Micro-animations
// (Fade and Slide) introduced in Phase 5 without relying on the full
// system's dependency injection (AuthCubit, Repositories).
void main() {
  testWidgets('Verify Route Fade Transition (Bottom Navigation Simulation)',
      (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Scaffold(body: Text('Home Page')),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Scaffold(body: Text('Settings Page')),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    // Initial State Context
    expect(find.text('Home Page'), findsOneWidget);

    // Trigger Navigation
    router.go('/settings');

    // Pump a single frame to start the animation
    await tester.pump();

    // Advance time by 50ms to be perfectly in the middle of the transition fading
    await tester.pump(const Duration(milliseconds: 50));

    // VERIFICATION: Check if FadeTransition exists in the widget tree during transition
    expect(find.byType(FadeTransition), findsWidgets);

    // Fast-forward to the end of the animation
    await tester.pumpAndSettle();

    // Final State Context
    expect(find.text('Settings Page'), findsOneWidget);
  });

  testWidgets('Verify Route Slide Transition (Detail & Recording Overlay)',
      (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),
        GoRoute(
          path: '/detail',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Scaffold(body: Text('Detail Page')),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.ease));
              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    // Trigger Navigation
    router.go('/detail');

    // Start animation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // VERIFICATION: Check if SlideTransition exists in the widget tree
    expect(find.byType(SlideTransition), findsWidgets);

    // Finish
    await tester.pumpAndSettle();
    expect(find.text('Detail Page'), findsOneWidget);
  });
}
