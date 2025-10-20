import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'blocker.dart';
import 'preferences.dart';

class TabManager extends ChangeNotifier {
  TabManager({required this.blocker, required this.prefs}) {
    openNewTab();
  }

  final ContentBlocker blocker;
  final BrowserPreferences prefs;

  final urlController = TextEditingController();
  final List<TabData> tabs = [];
  int activeIndex = 0;

  WebViewController? get activeController =>
      tabs.isNotEmpty ? tabs[activeIndex].controller : null;

  void openNewTab() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          urlController.text = url;
        },
        onNavigationRequest: (request) {
          if (prefs.privateMode && !request.isForMainFrame) {
            return NavigationDecision.prevent;
          }
          if (blocker.shouldBlock(request.url)) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));

    final tab = TabData(title: 'New Tab', controller: controller);
    tabs.add(tab);
    activeIndex = tabs.length - 1;
    notifyListeners();
  }

  void closeTab(int index) {
    if (index < 0 || index >= tabs.length) return;
    tabs.removeAt(index);
    if (activeIndex >= tabs.length) {
      activeIndex = tabs.isEmpty ? 0 : tabs.length - 1;
    }
    notifyListeners();
  }

  void setActiveIndex(int index) {
    if (index < 0 || index >= tabs.length) return;
    activeIndex = index;
    final tab = tabs[activeIndex];
    urlController.text = tab.controller.value.currentUrl ?? '';
    notifyListeners();
  }

  Future<void> loadUrl(String url) async {
    if (tabs.isEmpty) openNewTab();
    final controller = tabs[activeIndex].controller;
    final finalUrl = url.contains('://') ? url : 'https://$url';
    await controller.loadRequest(Uri.parse(finalUrl));
  }
}

class TabData {
  TabData({required this.title, required this.controller});

  final String title;
  final WebViewController controller;
}

class TabStrip extends StatelessWidget {
  const TabStrip({
    super.key,
    required this.tabs,
    required this.onTabSelected,
    required this.onNewTab,
    required this.onCloseTab,
    required this.activeIndex,
  });

  final List<TabData> tabs;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onNewTab;
  final ValueChanged<int> onCloseTab;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        border: const Border(top: BorderSide(color: Color(0xFF2d1b4c))),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final active = index == activeIndex;
                return GestureDetector(
                  onTap: () => onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF7c3aed).withOpacity(0.4)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          tab.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => onCloseTab(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: tabs.length,
            ),
          ),
          IconButton(
            onPressed: onNewTab,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
