import 'package:flutter/material.dart';

class UpdatesPage extends StatefulWidget {
  const UpdatesPage({super.key});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  bool _checking = false;
  List<String> _updates = const [];

  Future<void> _checkUpdates() async {
    setState(() => _checking = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _updates = const [
        'apt: linux-generic security update',
        'flatpak: com.discordapp.Discord runtime refresh',
      ];
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Updates')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _checking ? null : _checkUpdates,
              child: const Text('Check for updates'),
            ),
            if (_checking) const LinearProgressIndicator(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _updates.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_updates[index]),
                  trailing: const Icon(Icons.system_update_alt),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
