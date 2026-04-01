import '../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Consume `/api/membership-plans` para mostrar los planes comerciales
/// disponibles dentro de la app.
class MembershipService {
  MembershipService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MembershipPlanModel>> obtenerPlanesMembresia() async {
    final response =
        await _apiClient.get<List<dynamic>>('/api/membership-plans');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(MembershipPlanModel.fromJson)
        .toList();
  }

  Future<List<MembershipPlanModel>> fetchPlans() => obtenerPlanesMembresia();
}
