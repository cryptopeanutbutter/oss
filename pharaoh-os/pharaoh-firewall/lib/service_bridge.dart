import 'dart:convert';
import 'dart:io';

class FirewallServiceBridge {
  Future<void> applyPreset(String preset) async {
    final result = await Process.run('pkexec', ['/usr/local/bin/pharaoh-firewall', preset]);
    if (result.exitCode != 0) {
      throw Exception('Failed to apply preset: ${result.stderr}');
    }
  }

  Future<String> readActivePreset() async {
    final file = File('/etc/default/pharaoh-os');
    if (!file.existsSync()) return 'normal';
    final lines = const LineSplitter().convert(await file.readAsString());
    for (final line in lines) {
      if (line.startsWith('PHARAOH_FIREWALL_PRESET')) {
        return line.split('=').last.replaceAll('"', '').trim();
      }
    }
    return 'normal';
  }
}
