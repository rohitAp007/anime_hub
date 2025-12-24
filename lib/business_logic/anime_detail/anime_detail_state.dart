import 'package:equatable/equatable.dart';
import 'package:anime_hub/data/models/anime.dart';

abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();

  @override
  List<Object?> get props => [];
}

class AnimeDetailInitial extends AnimeDetailState {
  const AnimeDetailInitial();
}

class AnimeDetailLoading extends AnimeDetailState {
  const AnimeDetailLoading();
}

class AnimeDetailLoaded extends AnimeDetailState {
  final Anime anime;
  final List<Anime> trendingAnime;

  const AnimeDetailLoaded({
    required this.anime,
    required this.trendingAnime,
  });

  @override
  List<Object?> get props => [anime, trendingAnime];
}

class AnimeDetailError extends AnimeDetailState {
  final String message;

  const AnimeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
