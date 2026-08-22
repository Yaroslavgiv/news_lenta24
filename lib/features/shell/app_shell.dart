import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../feed/pages/home_page.dart';
import '../feed/pages/last24_page.dart';
import '../search/search_page.dart';
import '../sources/pages/sources_page.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int index = 0;

  static const _titles = ['LENTA24', '24 ЧАСА', 'ИСТОЧНИКИ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[index]),
        leading: IconButton(
          tooltip: 'Поиск',
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchPage()),
            );
          },
        ),
        actions: [
          if (index == 0)
            IconButton(
              tooltip: 'Отметить всё прочитанным',
              icon: const Icon(Icons.done_all_rounded),
              onPressed: () => ref.read(lentaFeedProvider).markAllAsRead(),
            ),
          if (index == 1)
            IconButton(
              tooltip: 'Отметить всё прочитанным',
              icon: const Icon(Icons.done_all_rounded),
              onPressed: () => ref.read(last24FeedProvider).markAllAsRead(),
            ),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: const [
          HomePage(),
          Last24Page(),
          SourcesPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Лента',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule_rounded),
            label: '24 часа',
          ),
          NavigationDestination(
            icon: Icon(Icons.source_outlined),
            selectedIcon: Icon(Icons.source_rounded),
            label: 'Источники',
          ),
        ],
      ),
    );
  }
}
