import 'api_exception.dart';

class ApiErrorMapper {
  static String messageFor(
    ApiException exception, {
    required String offlineMessage,
    required String fallbackMessage,
    String? badRequestMessage,
    String? unauthorizedMessage,
    String? forbiddenMessage,
    String? notFoundMessage,
    String? conflictMessage,
  }) {
    if (_isConnectivityError(exception)) {
      return offlineMessage;
    }

    switch (exception.statusCode) {
      case 400:
        return badRequestMessage ?? fallbackMessage;
      case 401:
        return unauthorizedMessage ?? fallbackMessage;
      case 403:
        return forbiddenMessage ?? fallbackMessage;
      case 404:
        return notFoundMessage ?? fallbackMessage;
      case 409:
        return conflictMessage ?? fallbackMessage;
      default:
        return fallbackMessage;
    }
  }

  static bool _isConnectivityError(ApiException exception) {
    if (exception.statusCode == null) {
      return true;
    }

    final message = exception.message.toLowerCase();
    return message.contains('xmlhttprequest') ||
        message.contains('onerror') ||
        message.contains('socketexception') ||
        message.contains('connection');
  }
}
