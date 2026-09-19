import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/game_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String game = '/game';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        game: (context) => const GameScreen(),
        settings: (context) => const SettingsScreen(),
      };
}
