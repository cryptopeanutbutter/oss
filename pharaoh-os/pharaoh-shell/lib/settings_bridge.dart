import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'taskbar.dart';

class SettingsBridge {
  final _firewallPresetController = StreamController<String>.broadcast();

  Stream<String> get firewallPresetStream => _firewallPresetController.stream;

  Future<List<AppEntry>> discoverApps() async {
    final directories = <Directory>[
      Directory('/usr/share/applications'),
      Directory('/usr/local/share/applications'),
      if (Platform.environment['HOME'] != null)
        Directory(p.join(Platform.environment['HOME']!, '.local/share/applications')),
    ];

    final entries = <AppEntry>[];
    for (final dir in directories) {
      if (!dir.existsSync()) continue;
      await for (final file in dir.list()) {
        if (!file.path.endsWith('.desktop')) continue;
        final app = _parseDesktopFile(File(file.path));
        if (app != null) entries.add(app);
      }
    }
    entries.sort((a, b) => a.name.compareTo(b.name));
    return entries;
  }

  List<TrayItem> readTrayItems() {
    return const [
      TrayItem(tooltip: 'Network', icon: Icons.wifi),
      TrayItem(tooltip: 'Volume', icon: Icons.volume_up),
      TrayItem(tooltip: 'Battery', icon: Icons.battery_charging_full),
    ];
  }

  Future<void> launchDesktopFile(String desktopFile) async {
    await Process.run('gtk-launch', [desktopFile]);
  }

  List<AppInstance> enumerateRunningApps() {
    // Placeholder: in production this would query Wayland compositor or xdg-desktop-portal.
    return const [];
  }

  void focusWindow(String windowId) {
    Process.run('swaymsg', ['[con_id=$windowId] focus']);
  }

  void setFirewallPreset(String preset) {
    _firewallPresetController.add(preset);
    Process.run('pkexec', ['/usr/local/bin/pharaoh-firewall', preset]);
  }
}

AppEntry? _parseDesktopFile(File file) {
  try {
    final lines = file.readAsLinesSync();
    String name = file.uri.pathSegments.last.replaceAll('.desktop', '');
    String exec = '';
    final keywords = <String>[];
    for (final line in lines) {
      if (line.startsWith('Name=')) {
        name = line.substring(5);
      } else if (line.startsWith('Exec=')) {
        exec = line.substring(5);
      } else if (line.startsWith('Keywords=')) {
        keywords.addAll(line.substring(9).split(';').where((k) => k.isNotEmpty));
      }
    }
    return AppEntry(
      name: name,
      desktopFile: file.uri.pathSegments.last,
      exec: exec,
      keywords: keywords,
      icon: _pickIconForExec(exec),
    );
  } catch (err) {
    stderr.writeln('Failed to parse desktop file ${file.path}: $err');
    return null;
  }
}

IconData _pickIconForExec(String exec) {
  if (exec.contains('gnome-terminal') || exec.contains('alacritty')) {
    return Icons.terminal;
  }
  if (exec.toLowerCase().contains('firefox') || exec.contains('browser')) {
    return Icons.language;
  }
  if (exec.toLowerCase().contains('steam')) {
    return Icons.sports_esports;
  }
  if (exec.toLowerCase().contains('discord')) {
    return Icons.chat_bubble;
  }
  return Icons.apps;
}

class AppEntry {
  AppEntry({
    required this.name,
    required this.desktopFile,
    required this.exec,
    required this.icon,
    required this.keywords,
  });

  final String name;
  final String desktopFile;
  final String exec;
  final IconData icon;
  final List<String> keywords;
}
