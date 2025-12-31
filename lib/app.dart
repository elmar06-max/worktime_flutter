import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/navigation/providers/bottom_navigation_provider.dart';
import 'features/home/presentation/home_page.dart';
import 'features/overview/presentation/overview_page.dart';
import 'features/settings/presentation/settings_page.dart';

class WorkTimeApp extends ConsumerWidget {
  const WorkTimeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(bottomNavigationProvider);

    return MaterialApp(
      title: 'WorkTime',
      theme: buildAppTheme(),
      home: Scaffold(
        body: IndexedStack(
          index: navigationState.index,
          children: const [
            HomePage(),
            OverviewPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationState.index,
          onDestinationSelected: (index) =>
              ref.read(bottomNavigationProvider.notifier).setIndex(index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
