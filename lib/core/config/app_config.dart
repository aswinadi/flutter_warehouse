import 'package:flutter/foundation.dart';

enum AppEnvironment { development, production }

class AppConfig {
  // Auto-detected from --dart-define=APP_ENV=production at build time.
  // Falls back to 'development' when not set (e.g. `flutter run` without flags).
  static const _flavorString =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static final AppEnvironment environment = _flavorString == 'production'
      ? AppEnvironment.production
      : AppEnvironment.development;

  /// Manually override the environment (used by main_development / main_production
  /// entry points for IDE run configurations that don't pass --dart-define).
  static AppEnvironment _override = environment;

  static void initialize(AppEnvironment env) {
    _override = env;
  }

  static AppEnvironment get currentEnvironment => _override;

  static const String devBaseUrl = 'https://biogeographic-raylan-interdentally.ngrok-free.dev/api/v1/';
  static const String prodBaseUrl = 'https://warehouse.maxmar.net/api/v1/';

  static String get baseUrl {
    switch (_override) {
      case AppEnvironment.production:
        return prodBaseUrl;
      case AppEnvironment.development:
      default:
        return devBaseUrl;
    }
  }

  // You can add other environment-specific variables here later
  static bool get isDev => _override == AppEnvironment.development;
}
