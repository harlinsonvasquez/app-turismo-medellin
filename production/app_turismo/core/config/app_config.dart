import 'package:flutter/foundation.dart';

/// Centraliza la URL base del backend segun la plataforma donde corre Flutter.
class ConfiguracionApi {
  static const _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    final configuredUrl = _apiBaseUrlOverride.isNotEmpty
        ? _apiBaseUrlOverride
        : _defaultLocalBackendUrl();
    return _normalizeBaseUrl(configuredUrl);
  }

  static String _defaultLocalBackendUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'http://localhost:8080';
    }
  }

  static String _normalizeBaseUrl(String value) =>
      value.endsWith('/') ? value.substring(0, value.length - 1) : value;
}

/// Alias de compatibilidad para no romper referencias previas durante el refactor.
class AppConfig extends ConfiguracionApi {}
