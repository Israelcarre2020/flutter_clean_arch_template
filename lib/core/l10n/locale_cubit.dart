import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit to manage application locale (language)
/// Persists locale preference using SharedPreferences
class LocaleCubit extends Cubit<Locale> {

  LocaleCubit(this._prefs) : super(const Locale('en')) {
    _loadLocale();
  }
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('es'), // Spanish
  ];

  /// Load locale from persistent storage
  void _loadLocale() {
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      emit(Locale(savedLocale));
    }
  }

  /// Change locale
  Future<void> changeLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      await _prefs.setString(_localeKey, locale.languageCode);
      emit(locale);
    }
  }

  /// Toggle between English and Spanish
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en'
        ? const Locale('es')
        : const Locale('en');
    await changeLocale(newLocale);
  }

  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'es':
        return 'Español';
      case 'en':
      default:
        return 'English';
    }
  }
}
