import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'animations.dart';
import 'launcher.dart';
import 'settings_bridge.dart';
import 'taskbar.dart';
import 'theme.dart';

defaultFutureErrorHandler(Object error, StackTrace stack) {
  stderr.writeln('[pharaoh-shell] Uncaught error: $error');
  stderr.writeln(stack);
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    stderr.writeln(details.exceptionAsString());
    stderr.writeln(details.stack);
  };
  runZonedGuarded(() async {
    final themeLoader = ThemeLoader();
    final settings = SettingsBridge();
    final shellState = ShellState(themeLoader: themeLoader, settings: settings);
    await shellState.loadInitialState();

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => shellState),
      ],
      child: const PharaohShellApp(),
    ));
  }, defaultFutureErrorHandler);
}

class PharaohShellApp extends StatelessWidget {
  const PharaohShellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShellState>(
      builder: (context, state, _) {
        final theme = state.currentTheme;
        final colorScheme = ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: theme.accent,
          background: theme.background,
        );
        return MaterialApp(
          title: 'Pharaoh Shell',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: theme.background,
            textTheme: ThemeData.dark().textTheme.apply(
                  bodyColor: theme.textPrimary,
                  displayColor: theme.textPrimary,
                ),
            useMaterial3: true,
          ),
          home: const ShellHome(),
        );
      },
    );
  }
}

class ShellHome extends StatefulWidget {
  const ShellHome({super.key});

  @override
  State<ShellHome> createState() => _ShellHomeState();
}

class _ShellHomeState extends State<ShellHome> {
  bool _showLauncher = false;
  late StreamSubscription _presetSub;

  @override
  void initState() {
    super.initState();
    final shellState = context.read<ShellState>();
    _presetSub = shellState.settings.firewallPresetStream.listen((preset) {
      shellState.setActiveFirewallPreset(preset);
    });
  }

  @override
  void dispose() {
    _presetSub.cancel();
    super.dispose();
  }

  void toggleLauncher() {
    setState(() => _showLauncher = !_showLauncher);
  }

  @override
  Widget build(BuildContext context) {
    final shellState = context.watch<ShellState>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.2,
                  colors: [
                    shellState.currentTheme.background,
                    shellState.currentTheme.surface,
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Taskbar(
                apps: shellState.runningApps,
                onLauncherPressed: toggleLauncher,
                trayItems: shellState.trayItems,
                clock: DateFormat('HH:mm').format(DateTime.now()),
                onAppTapped: shellState.activateApp,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showLauncher ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            child: IgnorePointer(
              ignoring: !_showLauncher,
              child: Launcher(
                visible: _showLauncher,
                onClose: toggleLauncher,
                appEntries: shellState.launchableApps,
                onLaunch: (app) async {
                  await shellState.launchApp(app);
                  toggleLauncher();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShellState extends ChangeNotifier {
  ShellState({required this.themeLoader, required this.settings});

  final ThemeLoader themeLoader;
  final SettingsBridge settings;

  PharaohTheme _currentTheme = PharaohTheme.dark();
  List<AppEntry> _launchableApps = [];
  List<AppInstance> _runningApps = [];
  List<TrayItem> _trayItems = [];
  String _activeFirewallPreset = 'normal';

  PharaohTheme get currentTheme => _currentTheme;
  List<AppEntry> get launchableApps => _launchableApps;
  List<AppInstance> get runningApps => _runningApps;
  List<TrayItem> get trayItems => _trayItems;
  String get activeFirewallPreset => _activeFirewallPreset;

  Future<void> loadInitialState() async {
    _currentTheme = await themeLoader.loadDefaultTheme();
    _launchableApps = await settings.discoverApps();
    _trayItems = settings.readTrayItems();
    _runningApps = [];
    notifyListeners();
  }

  Future<void> launchApp(AppEntry app) async {
    await settings.launchDesktopFile(app.desktopFile);
    _runningApps = settings.enumerateRunningApps();
    notifyListeners();
  }

  void activateApp(AppInstance app) {
    settings.focusWindow(app.windowId);
  }

  Future<void> setThemeByName(String name) async {
    final theme = await themeLoader.loadThemeByName(name);
    if (theme != null) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void setActiveFirewallPreset(String preset) {
    _activeFirewallPreset = preset;
    notifyListeners();
  }
}
