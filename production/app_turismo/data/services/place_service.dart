import '../../core/network/api_client.dart';
import '../models/place_model.dart';

/// Consume `/api/places` y adapta el catalogo de lugares para la capa visual.
class PlaceService {
  PlaceService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PlaceModel>> obtenerLugares(
      {Map<String, dynamic>? filtros}) async {
    final response = await _apiClient.get<List<dynamic>>('/api/places',
        queryParameters: filtros);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(PlaceModel.fromJson)
        .toList();
  }

  Future<List<PlaceModel>> fetchPlaces({Map<String, dynamic>? query}) =>
      obtenerLugares(filtros: query);

  Future<PlaceModel> obtenerDetalleLugar(String id) async {
    final response =
        await _apiClient.get<Map<String, dynamic>>('/api/places/$id');
    return PlaceModel.fromJson(response.data ?? const {});
  }

  Future<PlaceModel> fetchPlaceDetail(String id) => obtenerDetalleLugar(id);
}
