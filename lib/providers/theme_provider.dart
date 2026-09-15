import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString("theme") ?? "system";

    switch (theme) {
      case "light":
        _themeMode = ThemeMode.light;
        break;
      case "dark":
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    if (mode == ThemeMode.light) {
      await prefs.setString("theme", "light");
    } else if (mode == ThemeMode.dark) {
      await prefs.setString("theme", "dark");
    } else {
      await prefs.setString("theme", "system");
    }

    _themeMode = mode;
    notifyListeners();
  }
}