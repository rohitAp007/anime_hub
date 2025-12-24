import 'package:equatable/equatable.dart';
import 'package:anime_hub/data/models/anime.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final Anime randomAnime;
  final List<Anime> trendingAnime;
  final List<Anime> upcomingAnime;

  const HomeLoaded({
    required this.randomAnime,
    required this.trendingAnime,
    required this.upcomingAnime,
  });

  @override
  List<Object?> get props => [randomAnime, trendingAnime, upcomingAnime];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
