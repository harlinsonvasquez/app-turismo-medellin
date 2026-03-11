import '../../core/network/api_client.dart';
import '../models/plan_model.dart';

class ItineraryService {
  ItineraryService(this._apiClient);

  final ApiClient _apiClient;

  Future<TripPlanModel> generatePlan(PlanInputModel input) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/itineraries/generate',
      data: input.toJson(),
    );
    return TripPlanModel.fromJson(response.data ?? const {});
  }

  Future<TripPlanModel> savePlan(TripPlanModel plan) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/itineraries',
      data: plan.toSaveRequest(),
    );
    return TripPlanModel.fromJson(response.data ?? const {});
  }

  Future<List<TripPlanModel>> fetchPlans() async {
    final response = await _apiClient.get<List<dynamic>>('/api/itineraries');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(TripPlanModel.fromJson)
        .toList();
  }

  Future<TripPlanModel> fetchPlan(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/api/itineraries/$id');
    return TripPlanModel.fromJson(response.data ?? const {});
  }
}
