import 'package:flutter/services.dart' show rootBundle;

class ContentBlocker {
  ContentBlocker._(this._rules);

  final List<String> _rules;

  static Future<ContentBlocker> load() async {
    final data = await rootBundle.loadString('assets/filters/easylist.txt');
    final rules = data
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !line.startsWith('#'))
        .toList(growable: false);
    return ContentBlocker._(rules);
  }

  bool shouldBlock(String url) {
    for (final rule in _rules) {
      if (rule.startsWith('||')) {
        final domain = rule.substring(2).replaceAll('^', '');
        if (url.contains(domain)) {
          return true;
        }
      }
    }
    return false;
  }
}
