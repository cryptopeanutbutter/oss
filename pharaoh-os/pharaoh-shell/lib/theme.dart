import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class PharaohTheme {
  PharaohTheme({
    required this.name,
    required this.background,
    required this.surface,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });

  factory PharaohTheme.dark() => PharaohTheme(
        name: 'dark',
        background: const Color(0xFF0b0b0f),
        surface: const Color(0xFF151521),
        accent: const Color(0xFF7c3aed),
        textPrimary: const Color(0xFFf8f7ff),
        textSecondary: const Color(0xFFb3b0d1),
      );

  final String name;
  final Color background;
  final Color surface;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
}

class ThemeLoader {
  final Directory _themeDir = Directory('/usr/share/pharaoh/themes');

  Future<PharaohTheme> loadDefaultTheme() async {
    final theme = await loadThemeByName('dark');
    return theme ?? PharaohTheme.dark();
  }

  Future<PharaohTheme?> loadThemeByName(String name) async {
    final file = File('${_themeDir.path}/$name.json');
    if (!file.existsSync()) return null;
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return PharaohTheme(
      name: data['name'] as String,
      background: _parseColor(data['background'] as String),
      surface: _parseColor(data['surface'] as String),
      accent: _parseColor(data['accent'] as String),
      textPrimary: _parseColor(data['textPrimary'] as String),
      textSecondary: _parseColor(data['textSecondary'] as String),
    );
  }

  Color _parseColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse(normalized, radix: 16) + 0xFF000000);
  }
}
