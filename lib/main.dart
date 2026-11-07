import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/root_screen.dart';

void main() {
  runApp(
    // CartProvider sits ABOVE MaterialApp, so every route
    // (including screens opened with Navigator.push) can read it.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeanBox',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
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