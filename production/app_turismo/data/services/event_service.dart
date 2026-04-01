import '../../core/network/api_client.dart';
import '../models/event_model.dart';

/// Consume `/api/events` y transforma la agenda del backend para la interfaz.
class EventService {
  EventService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<EventModel>> obtenerEventos(
      {Map<String, dynamic>? filtros}) async {
    final response = await _apiClient.get<List<dynamic>>('/api/events',
        queryParameters: filtros);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
  }

  Future<List<EventModel>> fetchEvents({Map<String, dynamic>? query}) =>
      obtenerEventos(filtros: query);

  Future<EventModel> obtenerDetalleEvento(String id) async {
    final response =
        await _apiClient.get<Map<String, dynamic>>('/api/events/$id');
    return EventModel.fromJson(response.data ?? const {});
  }

  Future<EventModel> fetchEventDetail(String id) => obtenerDetalleEvento(id);
}
