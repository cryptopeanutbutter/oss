import 'package:flutter/material.dart';

import 'settings_bridge.dart';

class Launcher extends StatefulWidget {
  const Launcher({
    super.key,
    required this.visible,
    required this.onClose,
    required this.onLaunch,
    required this.appEntries,
  });

  final bool visible;
  final VoidCallback onClose;
  final Future<void> Function(AppEntry) onLaunch;
  final List<AppEntry> appEntries;

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.appEntries
        .where((app) =>
            app.name.toLowerCase().contains(_query.toLowerCase()) ||
            app.keywords.any((k) => k.contains(_query.toLowerCase())))
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.fromLTRB(280, 80, 280, 120),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.72),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            blurRadius: 48,
            color: Color.fromARGB(120, 0, 0, 0),
          ),
        ],
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: widget.visible,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Search apps, commands, settings…',
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 5,
              childAspectRatio: 1,
              children: [
                for (final app in filtered)
                  _LauncherTile(
                    app: app,
                    onLaunch: () => widget.onLaunch(app),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LauncherTile extends StatelessWidget {
  const _LauncherTile({required this.app, required this.onLaunch});

  final AppEntry app;
  final VoidCallback onLaunch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onLaunch,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7c3aed).withOpacity(0.85),
                    const Color(0xFF9333ea).withOpacity(0.85),
                  ],
                ),
              ),
              child: Icon(app.icon, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              app.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
