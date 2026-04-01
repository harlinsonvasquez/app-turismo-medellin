import '../../core/network/api_client.dart';
import '../models/plan_model.dart';

/// Encapsula el flujo de generacion y persistencia de itinerarios.
/// Usa `/api/itineraries/generate`, `/api/itineraries` y el detalle por id.
class ItineraryService {
  ItineraryService(this._apiClient);

  final ApiClient _apiClient;

  Future<TripPlanModel> generarItinerario(PlanInputModel input) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/itineraries/generate',
      data: input.toJson(),
    );
    return TripPlanModel.fromJson(response.data ?? const {});
  }

  Future<TripPlanModel> generatePlan(PlanInputModel input) =>
      generarItinerario(input);

  Future<TripPlanModel> guardarItinerario(TripPlanModel plan) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/itineraries',
      data: plan.toSaveRequest(),
    );
    return TripPlanModel.fromJson(response.data ?? const {});
  }

  Future<TripPlanModel> savePlan(TripPlanModel plan) => guardarItinerario(plan);

  Future<List<TripPlanModel>> obtenerItinerarios() async {
    final response = await _apiClient.get<List<dynamic>>('/api/itineraries');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(TripPlanModel.fromJson)
        .toList();
  }

  Future<List<TripPlanModel>> fetchPlans() => obtenerItinerarios();

  Future<TripPlanModel> obtenerItinerario(String id) async {
    final response =
        await _apiClient.get<Map<String, dynamic>>('/api/itineraries/$id');
    return TripPlanModel.fromJson(response.data ?? const {});
  }

  Future<TripPlanModel> fetchPlan(String id) => obtenerItinerario(id);
}
