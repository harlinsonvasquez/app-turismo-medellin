import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class MembershipService {
  MembershipService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MembershipPlanModel>> fetchPlans() async {
    final response = await _apiClient.get<List<dynamic>>('/api/membership-plans');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(MembershipPlanModel.fromJson)
        .toList();
  }
}
