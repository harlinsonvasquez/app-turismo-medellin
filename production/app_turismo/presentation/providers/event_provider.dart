import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_service.dart';

/// Administra la carga, error y exito de la agenda obtenida desde `/api/events`.
class EventProvider extends ChangeNotifier {
  EventProvider(this._eventService);

  final EventService _eventService;

  List<EventModel> events = const [];
  bool isLoading = false;
  String? error;

  Future<void> cargarEventos({Map<String, dynamic>? filtros}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      events = await _eventService.obtenerEventos(filtros: filtros);
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar los eventos.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadEvents({Map<String, dynamic>? query}) =>
      cargarEventos(filtros: query);
}
