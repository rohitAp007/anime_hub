class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.jikan.moe/v4';
  
  // Endpoints
  static const String randomAnime = '/random/anime';
  static const String topAnime = '/top/anime';
  static const String upcomingAnime = '/seasons/upcoming';
  static const String searchAnime = '/anime';
  static String animeDetails(int id) => '/anime/$id/full';
  
  // Query Parameters
  static const String typeMovie = 'movie';
  static const String typeTv = 'tv';
  
  // Rate Limiting
  static const int requestsPerSecond = 3;
  static const int requestsPerMinute = 60;
  
  // Timeout
  static const Duration timeout = Duration(seconds: 30);
}
