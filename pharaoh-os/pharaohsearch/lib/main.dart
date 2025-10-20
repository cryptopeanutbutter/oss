import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'blocker.dart';
import 'preferences.dart';
import 'tabs.dart';
import 'urlbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final blocker = await ContentBlocker.load();
  final prefs = await BrowserPreferences.load();
  runApp(PharaohSearchApp(blocker: blocker, preferences: prefs));
}

class PharaohSearchApp extends StatelessWidget {
  const PharaohSearchApp({super.key, required this.blocker, required this.preferences});

  final ContentBlocker blocker;
  final BrowserPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabManager(blocker: blocker, prefs: preferences)),
        ChangeNotifierProvider(create: (_) => preferences),
      ],
      child: MaterialApp(
        title: 'PharaohSearch',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(primary: Color(0xFF7c3aed)),
          useMaterial3: true,
        ),
        home: const BrowserHome(),
      ),
    );
  }
}

class BrowserHome extends StatelessWidget {
  const BrowserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<TabManager>();
    final prefs = context.watch<BrowserPreferences>();
    final controller = manager.activeController;

    return Scaffold(
      backgroundColor: const Color(0xFF0f0f16),
      body: SafeArea(
        child: Column(
          children: [
            UrlBar(
              controller: manager.urlController,
              onSubmit: (text) => manager.loadUrl(text),
              isPrivate: prefs.privateMode,
              onPrivateToggle: prefs.togglePrivateMode,
            ),
            Expanded(
              child: controller != null
                  ? WebViewWidget(controller: controller)
                  : const Center(child: Text('Open a new tab to begin browsing.')),
            ),
            TabStrip(
              tabs: manager.tabs,
              onTabSelected: manager.setActiveIndex,
              onNewTab: manager.openNewTab,
              onCloseTab: manager.closeTab,
              activeIndex: manager.activeIndex,
            ),
          ],
        ),
      ),
    );
  }
}
