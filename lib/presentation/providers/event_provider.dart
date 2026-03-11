import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_service.dart';

class EventProvider extends ChangeNotifier {
  EventProvider(this._eventService);

  final EventService _eventService;

  List<EventModel> events = const [];
  bool isLoading = false;
  String? error;

  Future<void> loadEvents({Map<String, dynamic>? query}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      events = await _eventService.fetchEvents(query: query);
    } on ApiException catch (exception) {
      error = exception.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
