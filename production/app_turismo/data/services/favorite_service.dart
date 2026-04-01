import '../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Consume `/api/favorites` para persistir favoritos asociados al usuario
/// autenticado en el backend.
class FavoriteService {
  FavoriteService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FavoriteModel>> obtenerFavoritos() async {
    final response = await _apiClient.get<List<dynamic>>('/api/favorites');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(FavoriteModel.fromJson)
        .toList();
  }

  Future<List<FavoriteModel>> fetchFavorites() => obtenerFavoritos();

  Future<FavoriteModel> agregarFavorito(
      {required String itemType, required String referenceId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/favorites',
      data: {'itemType': itemType, 'referenceId': referenceId},
    );
    return FavoriteModel.fromJson(response.data ?? const {});
  }

  Future<FavoriteModel> addFavorite(
      {required String itemType, required String referenceId}) {
    return agregarFavorito(itemType: itemType, referenceId: referenceId);
  }

  Future<void> eliminarFavorito(String favoriteId) async {
    await _apiClient.delete<void>('/api/favorites/$favoriteId');
  }

  Future<void> removeFavorite(String favoriteId) =>
      eliminarFavorito(favoriteId);
}
