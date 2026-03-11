import '../../core/network/api_client.dart';
import '../models/place_model.dart';

class PlaceService {
  PlaceService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PlaceModel>> fetchPlaces({Map<String, dynamic>? query}) async {
    final response = await _apiClient.get<List<dynamic>>('/api/places', queryParameters: query);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(PlaceModel.fromJson)
        .toList();
  }

  Future<PlaceModel> fetchPlaceDetail(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/api/places/$id');
    return PlaceModel.fromJson(response.data ?? const {});
  }
}
