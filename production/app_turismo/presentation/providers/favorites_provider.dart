import 'package:flutter/foundation.dart';

import '../../core/error/api_error_mapper.dart';
import '../../core/error/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/services/favorite_service.dart';

/// Administra los favoritos guardados por el usuario autenticado y sincroniza
/// altas y bajas con `/api/favorites`.
class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._favoriteService);

  final FavoriteService _favoriteService;

  List<FavoriteModel> favorites = const [];
  bool isLoading = false;
  String? error;

  Future<void> cargarFavoritos() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      favorites = await _favoriteService.obtenerFavoritos();
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos cargar tus favoritos.',
        unauthorizedMessage: 'Inicia sesion para ver tus favoritos.',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() => cargarFavoritos();

  bool isFavoriteReference(String referenceId) =>
      favorites.any((item) => item.referenceId == referenceId);

  String? favoriteIdForReference(String referenceId) {
    final matches = favorites.where((item) => item.referenceId == referenceId);
    return matches.isEmpty ? null : matches.first.id;
  }

  Future<bool> alternarFavorito(
      {required String itemType, required String referenceId}) async {
    try {
      final existingId = favoriteIdForReference(referenceId);
      if (existingId != null) {
        await _favoriteService.eliminarFavorito(existingId);
        favorites = favorites.where((item) => item.id != existingId).toList();
      } else {
        final favorite = await _favoriteService.agregarFavorito(
            itemType: itemType, referenceId: referenceId);
        favorites = [favorite, ...favorites];
      }
      error = null;
      notifyListeners();
      return true;
    } on ApiException catch (exception) {
      error = ApiErrorMapper.messageFor(
        exception,
        offlineMessage: 'No se pudo conectar con el servidor.',
        fallbackMessage: 'No pudimos actualizar tus favoritos.',
        unauthorizedMessage: 'Inicia sesion para guardar favoritos.',
        conflictMessage: 'Ese lugar ya estaba en tus favoritos.',
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleFavorite(
      {required String itemType, required String referenceId}) {
    return alternarFavorito(itemType: itemType, referenceId: referenceId);
  }

  Future<void> limpiarSesion() async {
    favorites = const [];
    error = null;
    notifyListeners();
  }

  Future<void> clear() => limpiarSesion();
}
