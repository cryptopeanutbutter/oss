import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presets.dart';
import 'service_bridge.dart';

void main() {
  runApp(const PharaohFirewallApp());
}

class PharaohFirewallApp extends StatelessWidget {
  const PharaohFirewallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirewallViewModel(helper: FirewallServiceBridge()),
      child: MaterialApp(
        title: 'Pharaoh Firewall',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(primary: Color(0xFF7c3aed)),
          useMaterial3: true,
        ),
        home: const FirewallHome(),
      ),
    );
  }
}

class FirewallHome extends StatelessWidget {
  const FirewallHome({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FirewallViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firewall Presets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.refresh,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final preset in viewModel.presets)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                title: Text(preset.name),
                subtitle: Text(preset.description),
                trailing: viewModel.activePreset == preset.key
                    ? const Icon(Icons.check_circle, color: Color(0xFF7c3aed))
                    : null,
                onTap: () => viewModel.applyPreset(preset.key),
              ),
            ),
        ],
      ),
    );
  }
}
