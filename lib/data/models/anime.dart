import 'package:equatable/equatable.dart';
import 'package:anime_hub/data/models/anime_images.dart';
import 'package:anime_hub/data/models/anime_trailer.dart';
import 'package:anime_hub/data/models/genre.dart';

class Anime extends Equatable {
  final int malId;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final AnimeImages images;
  final AnimeTrailer? trailer;
  final String type;
  final String source;
  final int? episodes;
  final String status;
  final bool airing;
  final String? airedFrom;
  final String? airedTo;
  final String? duration;
  final String? rating;
  final double? score;
  final int? scoredBy;
  final int? rank;
  final int? popularity;
  final int? members;
  final int? favorites;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final List<Genre> genres;
  final List<Genre> themes;
  final List<Genre> demographics;

  const Anime({
    required this.malId,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    required this.images,
    this.trailer,
    required this.type,
    required this.source,
    this.episodes,
    required this.status,
    required this.airing,
    this.airedFrom,
    this.airedTo,
    this.duration,
    this.rating,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.genres = const [],
    this.themes = const [],
    this.demographics = const [],
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] as int,
      title: json['title'] as String? ?? 'Unknown',
      titleEnglish: json['title_english'] as String?,
      titleJapanese: json['title_japanese'] as String?,
      images: AnimeImages.fromJson(json['images'] ?? {}),
      trailer: json['trailer'] != null ? AnimeTrailer.fromJson(json['trailer']) : null,
      type: json['type'] as String? ?? 'Unknown',
      source: json['source'] as String? ?? 'Unknown',
      episodes: json['episodes'] as int?,
      status: json['status'] as String? ?? 'Unknown',
      airing: json['airing'] as bool? ?? false,
      airedFrom: json['aired']?['from'] as String?,
      airedTo: json['aired']?['to'] as String?,
      duration: json['duration'] as String?,
      rating: json['rating'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      scoredBy: json['scored_by'] as int?,
      rank: json['rank'] as int?,
      popularity: json['popularity'] as int?,
      members: json['members'] as int?,
      favorites: json['favorites'] as int?,
      synopsis: json['synopsis'] as String?,
      background: json['background'] as String?,
      season: json['season'] as String?,
      year: json['year'] as int?,
      genres: (json['genres'] as List?)?.map((e) => Genre.fromJson(e)).toList() ?? [],
      themes: (json['themes'] as List?)?.map((e) => Genre.fromJson(e)).toList() ?? [],
      demographics: (json['demographics'] as List?)?.map((e) => Genre.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'title_english': titleEnglish,
      'title_japanese': titleJapanese,
      'images': images.toJson(),
      'trailer': trailer?.toJson(),
      'type': type,
      'source': source,
      'episodes': episodes,
      'status': status,
      'airing': airing,
      'aired': {
        'from': airedFrom,
        'to': airedTo,
      },
      'duration': duration,
      'rating': rating,
      'score': score,
      'scored_by': scoredBy,
      'rank': rank,
      'popularity': popularity,
      'members': members,
      'favorites': favorites,
      'synopsis': synopsis,
      'background': background,
      'season': season,
      'year': year,
      'genres': genres.map((e) => e.toJson()).toList(),
      'themes': themes.map((e) => e.toJson()).toList(),
      'demographics': demographics.map((e) => e.toJson()).toList(),
    };
  }

  // Helper methods
  String get displayTitle => titleEnglish ?? title;
  
  String get posterUrl => images.jpg.largeImageUrl ?? 
                          images.jpg.imageUrl ?? 
                          images.webp.largeImageUrl ?? 
                          images.webp.imageUrl ?? 
                          '';
  
  String get smallPosterUrl => images.jpg.smallImageUrl ?? 
                               images.jpg.imageUrl ?? 
                               '';
  
  bool get hasTrailer => trailer?.hasTrailer ?? false;
  
  String get scoreText => score != null ? score!.toStringAsFixed(2) : 'N/A';
  
  String get yearText => year?.toString() ?? 'TBA';
  
  String get genresText => [...genres, ...themes, ...demographics]
      .map((g) => g.name)
      .take(3)
      .join(', ');
  
  String get shortSynopsis => synopsis != null && synopsis!.length > 150
      ? '${synopsis!.substring(0, 150)}...'
      : synopsis ?? 'No synopsis available.';

  @override
  List<Object?> get props => [
        malId,
        title,
        titleEnglish,
        titleJapanese,
        images,
        trailer,
        type,
        source,
        episodes,
        status,
        airing,
        score,
      ];
}
