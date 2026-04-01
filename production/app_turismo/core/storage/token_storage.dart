import 'package:shared_preferences/shared_preferences.dart';

/// Persiste el token JWT usado por el frontend para autenticarse contra
/// `/api/auth/login`, `/api/auth/register` y endpoints protegidos.
class AlmacenamientoToken {
  static const _tokenKey = 'auth_token';

  Future<void> guardarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> leerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> limpiarToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

/// Mantiene compatibilidad con el nombre original mientras el codigo adopta
/// gradualmente nombres mas explicitos en espanol.
class TokenStorage extends AlmacenamientoToken {
  Future<void> saveToken(String token) => guardarToken(token);

  Future<String?> readToken() => leerToken();

  Future<void> clearToken() => limpiarToken();
}
