import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/data/services/api_service.dart';
import 'package:anime_hub/core/constants/api_constants.dart';

class AnimeRepository {
  final ApiService apiService;

  AnimeRepository({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  /// Get random anime
  Future<Anime> getRandomAnime() async {
    try {
      final response = await apiService.get(ApiConstants.randomAnime);
      return Anime.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch random anime: $e');
    }
  }

  /// Get top anime (trending)
  Future<List<Anime>> getTopAnime({String? type, int limit = 20}) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await apiService.get(
        ApiConstants.topAnime,
        queryParams: queryParams,
      );

      final List<dynamic> data = response['data'];
      return data.map((json) => Anime.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch top anime: $e');
    }
  }

  /// Get upcoming anime
  Future<List<Anime>> getUpcomingAnime({int limit = 20}) async {
    try {
      final response = await apiService.get(
        ApiConstants.upcomingAnime,
        queryParams: {'limit': limit.toString()},
      );

      final List<dynamic> data = response['data'];
      return data.map((json) => Anime.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming anime: $e');
    }
  }

  /// Search anime by query
  Future<List<Anime>> searchAnime(String query, {int limit = 20}) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final response = await apiService.get(
        ApiConstants.searchAnime,
        queryParams: {
          'q': query,
          'limit': limit.toString(),
        },
      );

      final List<dynamic> data = response['data'];
      return data.map((json) => Anime.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search anime: $e');
    }
  }

  /// Get anime details by ID
  Future<Anime> getAnimeDetails(int id) async {
    try {
      final response = await apiService.get(ApiConstants.animeDetails(id));
      return Anime.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to fetch anime details: $e');
    }
  }

  void dispose() {
    apiService.dispose();
  }
}
