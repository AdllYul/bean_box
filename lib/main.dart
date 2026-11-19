import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'providers/cart_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/root_screen.dart';
import 'vault/services/vault_storage.dart';

Future<void> main() async {
  // Needed before using plugins (SharedPreferences) ahead of runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Load everything from disk BEFORE the first frame is drawn.
  // This is what prevents the white flash when the saved theme is dark.
  final prefs = await SharedPreferences.getInstance();
  final storage = VaultStorage(prefs);

  runApp(
    // Providers sit ABOVE MaterialApp, so every route can read them.
    MultiProvider(
      providers: [
        Provider<VaultStorage>.value(value: storage),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<SettingsProvider, bool>(
      (settings) => settings.isDarkMode,
    );

    return MaterialApp(
      title: 'BeanBox',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const RootScreen(),
    );
  }
}
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}