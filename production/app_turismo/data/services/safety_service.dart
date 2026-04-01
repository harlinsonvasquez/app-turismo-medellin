import '../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Consume `/api/safety-tips` y entrega consejos listos para la UI.
class SafetyService {
  SafetyService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SafetyTipModel>> obtenerConsejosSeguridad(
      {String? city, String? zone}) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/api/safety-tips',
      queryParameters: {'city': city, 'zone': zone},
    );
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(SafetyTipModel.fromJson)
        .toList();
  }

  Future<List<SafetyTipModel>> fetchSafetyTips({String? city, String? zone}) {
    return obtenerConsejosSeguridad(city: city, zone: zone);
  }
}
