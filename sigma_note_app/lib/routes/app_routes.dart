import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/notes_screen/notes_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String settings = '/settings-screen';
  static const String login = '/login-screen';
  static const String notes = '/notes-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const SettingsScreen(),
    login: (context) => const LoginScreen(),
    notes: (context) => const NotesScreen(),
    // TODO: Add your other routes here
  };
}
