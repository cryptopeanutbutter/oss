import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrowserPreferences extends ChangeNotifier {
  BrowserPreferences._(this._prefs, this._privateMode);

  final SharedPreferences _prefs;
  bool _privateMode;

  bool get privateMode => _privateMode;

  static Future<BrowserPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final privateMode = prefs.getBool('privateMode') ?? false;
    return BrowserPreferences._(prefs, privateMode);
  }

  void togglePrivateMode() {
    _privateMode = !_privateMode;
    _prefs.setBool('privateMode', _privateMode);
    notifyListeners();
  }
}
