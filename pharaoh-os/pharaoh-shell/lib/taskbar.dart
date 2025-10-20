import 'package:flutter/material.dart';
import 'animations.dart';

class Taskbar extends StatelessWidget {
  const Taskbar({
    super.key,
    required this.apps,
    required this.onAppTapped,
    required this.onLauncherPressed,
    required this.trayItems,
    required this.clock,
  });

  final List<AppInstance> apps;
  final void Function(AppInstance) onAppTapped;
  final VoidCallback onLauncherPressed;
  final List<TrayItem> trayItems;
  final String clock;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(120, 0, 0, 0),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.purple.withOpacity(0.35), width: 1.2),
      ),
      child: Row(
        children: [
          _LauncherButton(onTap: onLauncherPressed),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Row(
                key: ValueKey(apps.length),
                children: [
                  for (final app in apps)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _TaskbarButton(
                        instance: app,
                        onTap: () => onAppTapped(app),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              for (final tray in trayItems)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Tooltip(
                    message: tray.tooltip,
                    child: Icon(
                      tray.icon,
                      color: Colors.white.withOpacity(0.82),
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Text(
                clock,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskbarButton extends StatefulWidget {
  const _TaskbarButton({required this.instance, required this.onTap});

  final AppInstance instance;
  final VoidCallback onTap;

  @override
  State<_TaskbarButton> createState() => _TaskbarButtonState();
}

class _TaskbarButtonState extends State<_TaskbarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeScaleTransition(
      controller: _controller,
      child: Material(
        color: Colors.white.withOpacity(widget.instance.focused ? 0.16 : 0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.instance.icon, size: 20),
                const SizedBox(height: 4),
                Text(
                  widget.instance.title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LauncherButton extends StatelessWidget {
  const _LauncherButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF7c3aed), Color(0xFF9333ea)],
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              spreadRadius: 1,
              color: Color.fromARGB(90, 100, 60, 255),
            ),
          ],
        ),
        child: const Icon(Icons.apps, color: Colors.white),
      ),
    );
  }
}

class AppInstance {
  AppInstance({
    required this.windowId,
    required this.title,
    required this.icon,
    this.focused = false,
  });

  final String windowId;
  final String title;
  final IconData icon;
  final bool focused;
}

class TrayItem {
  const TrayItem({required this.tooltip, required this.icon});

  final String tooltip;
  final IconData icon;
}
