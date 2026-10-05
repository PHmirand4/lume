import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navegação principal: Início · Mapa · Focos · Guia.
class ShellPrincipal extends StatelessWidget {
  const ShellPrincipal({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Mapa'),
          NavigationDestination(
              icon: Icon(Icons.format_list_bulleted), selectedIcon: Icon(Icons.list_alt), label: 'Focos'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Guia'),
        ],
      ),
    );
  }
}
