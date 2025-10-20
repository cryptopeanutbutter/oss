import 'package:flutter/foundation.dart';

import 'service_bridge.dart';

class FirewallPreset {
  const FirewallPreset({required this.key, required this.name, required this.description});

  final String key;
  final String name;
  final String description;
}

class FirewallViewModel extends ChangeNotifier {
  FirewallViewModel({required this.helper}) {
    refresh();
  }

  final FirewallServiceBridge helper;
  final List<FirewallPreset> presets = const [
    FirewallPreset(
      key: 'strict',
      name: 'Strict',
      description: 'Block all inbound and most outbound connections except DNS.',
    ),
    FirewallPreset(
      key: 'normal',
      name: 'Normal',
      description: 'Balanced preset for daily usage with common ports allowed.',
    ),
    FirewallPreset(
      key: 'gaming',
      name: 'Gaming',
      description: 'Optimized for game launchers and voice chat while blocking unsolicited inbound.',
    ),
  ];

  String activePreset = 'normal';
  String? errorMessage;
  bool busy = false;

  Future<void> applyPreset(String preset) async {
    busy = true;
    notifyListeners();
    try {
      await helper.applyPreset(preset);
      activePreset = preset;
      errorMessage = null;
    } catch (err) {
      errorMessage = err.toString();
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    try {
      activePreset = await helper.readActivePreset();
      errorMessage = null;
    } catch (err) {
      errorMessage = err.toString();
    }
    notifyListeners();
  }
}
