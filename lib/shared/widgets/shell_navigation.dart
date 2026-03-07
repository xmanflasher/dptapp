import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dptapp/shared/widgets/navigation_drawer_widget.dart';

class ShellNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  static final GlobalKey<ScaffoldState> shellScaffoldKey = GlobalKey<ScaffoldState>();

  const ShellNavigation({
    super.key,
    required this.navigationShell,
  });

  @override
  State<ShellNavigation> createState() => _ShellNavigationState();
}

class _ShellNavigationState extends State<ShellNavigation> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.navigationShell.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleSwipe(double delta) {
    final int branches = widget.navigationShell.route.branches.length;
    int index = widget.navigationShell.currentIndex;

    if (delta > 50) { // Swipe Right -> Go Left
      if (index > 0) {
        widget.navigationShell.goBranch(index - 1);
      }
    } else if (delta < -50) { // Swipe Left -> Go Right
      if (index < branches - 1) {
        widget.navigationShell.goBranch(index + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    return Scaffold(
      key: ShellNavigation.shellScaffoldKey,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          _handleSwipe(details.primaryVelocity ?? 0);
        },
        child: widget.navigationShell,
      ),
      drawer: const NavigationDrawerWidget(),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: (index) => widget.navigationShell.goBranch(index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.loop_outlined),
                  activeIcon: Icon(Icons.loop),
                  label: 'Cycle',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center_outlined),
                  activeIcon: Icon(Icons.fitness_center),
                  label: 'Training',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_outlined),
                  activeIcon: Icon(Icons.group),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
