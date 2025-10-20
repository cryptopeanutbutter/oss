import 'package:flutter/material.dart';

class InstalledPage extends StatelessWidget {
  const InstalledPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apps = const [
      'PharaohSearch (system)',
      'Discord (Flatpak)',
      'Steam (Flatpak)',
      'Gnome Terminal',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Installed Apps')),
      body: ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return ListTile(
            title: Text(app),
            trailing: const Icon(Icons.launch),
          );
        },
      ),
    );
  }
}
