import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String _themeKey = 'themeMode';

  ThemeMode _currentThemeMode = ThemeMode.system;

  ThemeMode get currentThemeMode => _currentThemeMode;

  Future<void> loadInitialThemeMode() async {
    ThemeMode mode = await _getThemeMode();
    _currentThemeMode = mode;

    notifyListeners();
  }

  void changeThemeMode(ThemeMode mode) {
    if (_currentThemeMode == mode) return;

    _currentThemeMode = mode;
    _saveThemeMode(mode.name);

    notifyListeners();
  }

  Future<void> _saveThemeMode(String mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_themeKey, mode);
  }

  Future<ThemeMode> _getThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedThemeMode = sharedPreferences.getString(_themeKey) ?? '';
    return getThemeModeFromString(savedThemeMode);
  }

  ThemeMode getThemeModeFromString(String v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;

    }
  }
}


