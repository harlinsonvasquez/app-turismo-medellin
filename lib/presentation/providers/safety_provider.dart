import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/services/safety_service.dart';

class SafetyProvider extends ChangeNotifier {
  SafetyProvider(this._safetyService);

  final SafetyService _safetyService;

  List<SafetyTipModel> tips = const [];
  bool isLoading = false;
  String? error;

  Future<void> loadTips({String city = 'Medellin', String? zone}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      tips = await _safetyService.fetchSafetyTips(city: city, zone: zone);
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar los consejos de seguridad.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
