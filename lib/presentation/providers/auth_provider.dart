import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../core/storage/token_storage.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService, this._tokenStorage);

  final AuthService _authService;
  final TokenStorage _tokenStorage;

  UserModel? user;
  bool isLoading = false;
  bool initialized = false;
  String? error;

  bool get isAuthenticated => user != null;

  Future<void> bootstrap() async {
    if (initialized) return;
    initialized = true;
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) {
      notifyListeners();
      return;
    }
    try {
      user = await _authService.me();
    } catch (_) {
      await _tokenStorage.clearToken();
      user = null;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _authService.login(email: email, password: password);
      await _tokenStorage.saveToken(response.accessToken);
      user = response.user;
      return true;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No fue posible iniciar sesion.',
        badRequestMessage: 'Revisa los datos ingresados.',
        unauthorizedMessage: 'Correo o contrasena incorrectos.',
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _authService.register(fullName: fullName, email: email, password: password);
      await _tokenStorage.saveToken(response.accessToken);
      user = response.user;
      return true;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No fue posible crear la cuenta.',
        badRequestMessage: 'Revisa los datos de registro.',
        conflictMessage: 'Ya existe una cuenta con ese correo.',
      );
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    if (!isAuthenticated) return;
    try {
      user = await _authService.me();
      error = null;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar tu perfil.',
        unauthorizedMessage: 'Tu sesion ya no es valida. Inicia sesion nuevamente.',
      );
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    user = null;
    error = null;
    notifyListeners();
  }
}
