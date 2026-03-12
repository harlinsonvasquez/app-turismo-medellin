import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/plan_model.dart';
import '../../data/services/itinerary_service.dart';

class ItineraryProvider extends ChangeNotifier {
  ItineraryProvider(this._itineraryService);

  final ItineraryService _itineraryService;

  TripPlanModel? generatedPlan;
  List<TripPlanModel> savedPlans = const [];
  bool isLoading = false;
  String? error;

  Future<TripPlanModel?> generatePlan(PlanInputModel input) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      generatedPlan = await _itineraryService.generatePlan(input);
      return generatedPlan;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No se pudo generar el plan.',
        badRequestMessage: 'No se pudo generar el plan con los datos seleccionados.',
      );
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TripPlanModel?> saveCurrentPlan() async {
    if (generatedPlan == null) return null;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final saved = await _itineraryService.savePlan(generatedPlan!);
      generatedPlan = saved;
      savedPlans = [saved, ...savedPlans.where((item) => item.id != saved.id)];
      return saved;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No se pudo guardar el itinerario.',
        unauthorizedMessage: 'Inicia sesion para guardar el itinerario.',
      );
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedPlans() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      savedPlans = await _itineraryService.fetchPlans();
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar tus itinerarios.',
        unauthorizedMessage: 'Inicia sesion para ver tus itinerarios.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TripPlanModel?> loadPlan(String id) async {
    try {
      final plan = await _itineraryService.fetchPlan(id);
      generatedPlan = plan;
      notifyListeners();
      return plan;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar el itinerario.',
        unauthorizedMessage: 'Inicia sesion para ver ese itinerario.',
      );
      notifyListeners();
      return null;
    }
  }

  void clearSessionData() {
    savedPlans = const [];
    error = null;
    notifyListeners();
  }
}
