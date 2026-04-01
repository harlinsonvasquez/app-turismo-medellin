import '../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Consume los endpoints de autenticacion y transforma la respuesta del backend
/// en modelos que el frontend puede persistir y renderizar.
class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthResponseModel> iniciarSesion(
      {required String email, required String password}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data ?? const {});
  }

  Future<AuthResponseModel> login(
      {required String email, required String password}) {
    return iniciarSesion(email: email, password: password);
  }

  Future<AuthResponseModel> registrarUsuario(
      {required String fullName,
      required String email,
      required String password}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/auth/register',
      data: {'fullName': fullName, 'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data ?? const {});
  }

  Future<AuthResponseModel> register(
      {required String fullName,
      required String email,
      required String password}) {
    return registrarUsuario(
        fullName: fullName, email: email, password: password);
  }

  Future<UserModel> obtenerPerfilActual() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/api/auth/me');
    return UserModel.fromJson(response.data ?? const {});
  }

  Future<UserModel> me() => obtenerPerfilActual();
}
