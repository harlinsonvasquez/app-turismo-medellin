import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class FavoriteService {
  FavoriteService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FavoriteModel>> fetchFavorites() async {
    final response = await _apiClient.get<List<dynamic>>('/api/favorites');
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(FavoriteModel.fromJson)
        .toList();
  }

  Future<FavoriteModel> addFavorite({required String itemType, required String referenceId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/favorites',
      data: {'itemType': itemType, 'referenceId': referenceId},
    );
    return FavoriteModel.fromJson(response.data ?? const {});
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _apiClient.delete<void>('/api/favorites/$favoriteId');
  }
}
