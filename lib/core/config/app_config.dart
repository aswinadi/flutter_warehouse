import 'package:flutter/foundation.dart';

class AppConfig {
  static const String devBaseUrl = 'https://biogeographic-raylan-interdentally.ngrok-free.dev/api/v1/';
  static const String prodBaseUrl = 'https://warehouse.maxmar.net/api/v1/';

  static String get baseUrl {
    if (kReleaseMode) {
      return prodBaseUrl;
    }
    return devBaseUrl;
  }

  // You can add other environment-specific variables here later
  static bool get isDev => !kReleaseMode;
}
