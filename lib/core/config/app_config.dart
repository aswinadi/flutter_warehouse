import 'package:flutter/foundation.dart';

enum AppEnvironment { development, production }

class AppConfig {
  static AppEnvironment _environment = AppEnvironment.development;

  static void initialize(AppEnvironment env) {
    _environment = env;
  }

  static AppEnvironment get environment => _environment;

  static const String devBaseUrl = 'https://biogeographic-raylan-interdentally.ngrok-free.dev/api/v1/';
  static const String prodBaseUrl = 'https://warehouse.maxmar.net/api/v1/';

  static String get baseUrl {
    switch (_environment) {
      case AppEnvironment.production:
        return prodBaseUrl;
      case AppEnvironment.development:
      default:
        return devBaseUrl;
    }
  }

  // You can add other environment-specific variables here later
  static bool get isDev => _environment == AppEnvironment.development;
}
