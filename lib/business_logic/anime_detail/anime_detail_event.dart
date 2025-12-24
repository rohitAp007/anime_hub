import 'package:equatable/equatable.dart';

abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAnimeDetail extends AnimeDetailEvent {
  final int animeId;

  const LoadAnimeDetail(this.animeId);

  @override
  List<Object> get props => [animeId];
}
