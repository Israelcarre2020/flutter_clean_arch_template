import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit to manage application theme (dark/light mode)
/// Persists theme preference using SharedPreferences
class ThemeCubit extends Cubit<ThemeMode> {

  ThemeCubit(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }
  static const String _themeModeKey = 'theme_mode';
  final SharedPreferences _prefs;

  /// Load theme from persistent storage
  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeModeKey);
    if (savedTheme != null) {
      emit(_themeModeFromString(savedTheme));
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _saveTheme(newTheme);
    emit(newTheme);
  }

  /// Set specific theme mode
  Future<void> setTheme(ThemeMode themeMode) async {
    await _saveTheme(themeMode);
    emit(themeMode);
  }

  /// Save theme to persistent storage
  Future<void> _saveTheme(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.toString());
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Get current theme mode as boolean (true = dark, false = light)
  bool get isDarkMode => state == ThemeMode.dark;
}
