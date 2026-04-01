import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/place_model.dart';
import '../../data/services/place_service.dart';

/// Administra el estado del catalogo de lugares.
/// Orquesta filtros, destacados, cercanos y detalle desde `/api/places`.
class PlaceProvider extends ChangeNotifier {
  PlaceProvider(this._placeService);

  final PlaceService _placeService;

  List<PlaceModel> places = const [];
  List<PlaceModel> featuredPlaces = const [];
  List<PlaceModel> nearbyPlaces = const [];
  bool isLoading = false;
  String? error;

  Future<void> cargarLugares({Map<String, dynamic>? filtros}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      places = await _placeService.obtenerLugares(filtros: filtros);
      featuredPlaces = places.where((item) => item.isFeatured).toList();
      nearbyPlaces = places
          .where((item) => item.distanceKm > 0 && item.distanceKm <= 5)
          .toList();
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar los lugares.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlaces({Map<String, dynamic>? query}) =>
      cargarLugares(filtros: query);

  Future<PlaceModel?> cargarDetalleLugar(String id) async {
    try {
      return await _placeService.obtenerDetalleLugar(id);
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar el detalle del lugar.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<PlaceModel?> loadPlaceDetail(String id) => cargarDetalleLugar(id);
}
