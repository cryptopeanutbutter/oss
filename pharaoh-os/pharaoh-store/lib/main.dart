import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
import 'pages/installed.dart';
import 'pages/search.dart';
import 'pages/updates.dart';

void main() {
  runApp(const PharaohStoreApp());
}

class PharaohStoreApp extends StatefulWidget {
  const PharaohStoreApp({super.key});

  @override
  State<PharaohStoreApp> createState() => _PharaohStoreAppState();
}

class _PharaohStoreAppState extends State<PharaohStoreApp> {
  int _index = 0;

  final _pages = const [HomePage(), SearchPage(), InstalledPage(), UpdatesPage()];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreModel()),
      ],
      child: MaterialApp(
        title: 'Pharaoh Store',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(primary: Color(0xFF7c3aed)),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: _pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
              NavigationDestination(icon: Icon(Icons.apps), label: 'Installed'),
              NavigationDestination(icon: Icon(Icons.system_update), label: 'Updates'),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreModel extends ChangeNotifier {
  bool busy = false;
  String? message;

  Future<List<String>> search(String query) async {
    busy = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));
    busy = false;
    notifyListeners();
    return ['apt:$query', 'flatpak:$query'];
  }
}
