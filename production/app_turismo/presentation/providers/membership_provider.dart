import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/services/membership_service.dart';

/// Administra el estado de la consulta de planes de membresia.
class MembershipProvider extends ChangeNotifier {
  MembershipProvider(this._membershipService);

  final MembershipService _membershipService;

  List<MembershipPlanModel> plans = const [];
  bool isLoading = false;
  String? error;

  Future<void> cargarPlanesMembresia() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      plans = await _membershipService.obtenerPlanesMembresia();
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar los planes de membresia.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlans() => cargarPlanesMembresia();
}
