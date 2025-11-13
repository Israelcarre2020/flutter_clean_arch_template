/// Application environment enumeration
enum Environment {
  dev,
  integration,
  production;

  bool get isDev => this == Environment.dev;
  bool get isIntegration => this == Environment.integration;
  bool get isProduction => this == Environment.production;

  String get name {
    switch (this) {
      case Environment.dev:
        return 'Development';
      case Environment.integration:
        return 'Integration';
      case Environment.production:
        return 'Production';
    }
  }
}
