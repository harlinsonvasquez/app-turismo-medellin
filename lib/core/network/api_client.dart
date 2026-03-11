import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/api_exception.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient(this._tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 12),
            sendTimeout: const Duration(seconds: 12),
            headers: const {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.reject(error);
        },
      ),
    );
  }

  final Dio dio;
  final TokenStorage _tokenStorage;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get<T>(path, queryParameters: _cleanQuery(queryParameters));
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<T>> post<T>(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.post<T>(path, data: data, queryParameters: _cleanQuery(queryParameters));
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<T>> put<T>(String path, {Object? data}) async {
    try {
      return await dio.put<T>(path, data: data);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await dio.delete<T>(path);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Map<String, dynamic>? _cleanQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    final cleaned = <String, dynamic>{};
    query.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        cleaned[key] = value;
      }
    });
    return cleaned.isEmpty ? null : cleaned;
  }

  ApiException _mapError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (statusCode == null && error.response == null)) {
      return const ApiException(
        'No se pudo conectar con el servidor. Verifica que el backend este corriendo y disponible.',
      );
    }

    final backendMessage = data is Map<String, dynamic>
        ? (data['message']?.toString() ?? data['error']?.toString())
        : null;

    late final String message;
    if (statusCode == 400) {
      message = backendMessage ?? 'La solicitud no es valida.';
    } else if (statusCode == 401) {
      message = backendMessage ?? 'Necesitas iniciar sesion para continuar.';
    } else if (statusCode == 403) {
      message = backendMessage ?? 'El servidor rechazo la solicitud.';
    } else if (statusCode == 404) {
      message = backendMessage ?? 'No encontramos la informacion solicitada.';
    } else if (statusCode == 409) {
      message = backendMessage ?? 'Ya existe un registro con esos datos.';
    } else if (statusCode != null && statusCode >= 500) {
      message = backendMessage ?? 'El servidor tuvo un problema al procesar la solicitud.';
    } else {
      message = backendMessage ?? error.message ?? 'Ocurrio un error inesperado.';
    }

    return ApiException(message, statusCode: statusCode);
  }
}
