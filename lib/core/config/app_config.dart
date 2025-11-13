import 'package:gist/core/config/environment.dart';

/// Application configuration class
/// Contains all app-wide configuration settings based on environment
/// Loads configuration from environment variable maps
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogger,
    required this.apiTimeout,
  });

  /// Load configuration from environment map
  factory AppConfig.fromEnvMap(Map<String, String> env) {
    final envName = env['ENVIRONMENT'] ?? 'dev';
    final environment = _environmentFromString(envName);

    return AppConfig(
      environment: environment,
      apiBaseUrl:
          env['API_BASE_URL'] ?? 'https://official-joke-api.appspot.com',
      appName: env['APP_NAME'] ?? 'Gist',
      enableLogger: env['ENABLE_LOGGER']?.toLowerCase() == 'true',
      apiTimeout: Duration(
        seconds: int.tryParse(env['API_TIMEOUT'] ?? '30') ?? 30,
      ),
    );
  }

  // Development configuration (fallback)
  factory AppConfig.dev() {
    return const AppConfig(
      environment: Environment.dev,
      apiBaseUrl: 'https://official-joke-api.appspot.com',
      appName: 'Gist DEV',
      enableLogger: true,
      apiTimeout: Duration(seconds: 30),
    );
  }

  // Integration configuration (fallback)
  factory AppConfig.int() {
    return const AppConfig(
      environment: Environment.integration,
      apiBaseUrl: 'https://official-joke-api.appspot.com',
      appName: 'Gist INT',
      enableLogger: true,
      apiTimeout: Duration(seconds: 30),
    );
  }

  // Production configuration (fallback)
  factory AppConfig.prod() {
    return const AppConfig(
      environment: Environment.production,
      apiBaseUrl: 'https://official-joke-api.appspot.com',
      appName: 'Gist',
      enableLogger: false,
      apiTimeout: Duration(seconds: 20),
    );
  }

  final Environment environment;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogger;
  final Duration apiTimeout;

  /// Convert string to Environment enum
  static Environment _environmentFromString(String value) {
    switch (value.toLowerCase()) {
      case 'dev':
      case 'development':
        return Environment.dev;
      case 'int':
      case 'integration':
        return Environment.integration;
      case 'prod':
      case 'production':
        return Environment.production;
      default:
        return Environment.dev;
    }
  }

  AppConfig copyWith({
    Environment? environment,
    String? apiBaseUrl,
    String? appName,
    bool? enableLogger,
    Duration? apiTimeout,
  }) {
    return AppConfig(
      environment: environment ?? this.environment,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      appName: appName ?? this.appName,
      enableLogger: enableLogger ?? this.enableLogger,
      apiTimeout: apiTimeout ?? this.apiTimeout,
    );
  }
}
