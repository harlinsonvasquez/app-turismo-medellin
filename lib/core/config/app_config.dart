import 'package:flutter/foundation.dart';

/// Centraliza la URL base del backend segun la plataforma donde corre Flutter.
class ConfiguracionApi {
  static const _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

  /// IP de tu PC en la red local - cambia esto si tu IP cambia
  static const String _pcLocalIp = '192.168.1.4';
  static const String _backendPort = '8080';

  static String get apiBaseUrl {
    final configuredUrl = _apiBaseUrlOverride.isNotEmpty
        ? _apiBaseUrlOverride
        : _defaultLocalBackendUrl();
    return _normalizeBaseUrl(configuredUrl);
  }

  static String _defaultLocalBackendUrl() {
    if (kIsWeb) {
      return 'http://localhost:$_backendPort';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Usa la IP de tu PC para dispositivos Android fisicos
        // Para emulador, cambia a: http://10.0.2.2:$_backendPort
        return 'http://$_pcLocalIp:$_backendPort';
      case TargetPlatform.iOS:
        // iOS simulator usa localhost, dispositivos fisicos usan IP local
        return 'http://$_pcLocalIp:$_backendPort';
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'http://localhost:$_backendPort';
    }
  }

  static String _normalizeBaseUrl(String value) =>
      value.endsWith('/') ? value.substring(0, value.length - 1) : value;
}

/// Alias de compatibilidad para no romper referencias previas durante el refactor.
class AppConfig extends ConfiguracionApi {}
