import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Environment {
  dev('Development', 'assets/env/.env.dev'),
  int('Integration', 'assets/env/.env.int'),
  prod('Production', 'assets/env/.env.prod');

  const Environment(this.displayName, this.envFilePath);

  final String displayName;
  final String envFilePath;
}

class EnvironmentManager extends ChangeNotifier {
  EnvironmentManager(this._prefs) {
    _loadSavedEnvironment();
  }
  static const String _envKey = 'selected_environment';
  Environment _currentEnvironment = Environment.dev;
  final SharedPreferences _prefs;

  Environment get currentEnvironment => _currentEnvironment;

  Future<void> _loadSavedEnvironment() async {
    final savedEnvIndex = _prefs.getInt(_envKey);
    if (savedEnvIndex != null && savedEnvIndex < Environment.values.length) {
      _currentEnvironment = Environment.values[savedEnvIndex];
      notifyListeners();
    }
  }

  Future<void> setEnvironment(Environment environment) async {
    if (_currentEnvironment == environment) return;

    _currentEnvironment = environment;
    await _prefs.setInt(_envKey, environment.index);
    notifyListeners();
  }
}
