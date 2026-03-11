import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class SafetyService {
  SafetyService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SafetyTipModel>> fetchSafetyTips({String? city, String? zone}) async {
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
}
