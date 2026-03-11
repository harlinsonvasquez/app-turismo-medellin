import '../../core/network/api_client.dart';
import '../models/event_model.dart';

class EventService {
  EventService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<EventModel>> fetchEvents({Map<String, dynamic>? query}) async {
    final response = await _apiClient.get<List<dynamic>>('/api/events', queryParameters: query);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList();
  }

  Future<EventModel> fetchEventDetail(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/api/events/$id');
    return EventModel.fromJson(response.data ?? const {});
  }
}
