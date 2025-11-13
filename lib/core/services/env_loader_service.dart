import 'dart:developer';

import 'package:flutter/services.dart';

class EnvLoaderService {
  Future<Map<String, String>> loadEnvFile(String path) async {
    try {
      final envString = await rootBundle.loadString(path);
      return _parseEnvFile(envString);
    } catch (e) {
      log('Error loading env file from $path: $e');
      return {};
    }
  }

  Map<String, String> _parseEnvFile(String content) {
    final Map<String, String> result = {};
    final lines = content.split('\n');

    for (var line in lines) {
      line = line.trim();

      if (line.isEmpty || line.startsWith('#')) continue;

      final separatorIndex = line.indexOf('=');
      if (separatorIndex == -1) continue;

      final key = line.substring(0, separatorIndex).trim();
      var value = line.substring(separatorIndex + 1).trim();

      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      } else if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }
      result[key] = value;
    }

    return result;
  }
}
