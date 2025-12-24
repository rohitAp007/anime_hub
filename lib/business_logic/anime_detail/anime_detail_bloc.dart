import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/business_logic/anime_detail/anime_detail_event.dart';
import 'package:anime_hub/business_logic/anime_detail/anime_detail_state.dart';
import 'package:anime_hub/data/repositories/anime_repository.dart';
import 'package:anime_hub/data/models/anime.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final AnimeRepository animeRepository;

  AnimeDetailBloc({required this.animeRepository})
      : super(const AnimeDetailInitial()) {
    on<LoadAnimeDetail>(_onLoadAnimeDetail);
  }

  Future<void> _onLoadAnimeDetail(
    LoadAnimeDetail event,
    Emitter<AnimeDetailState> emit,
  ) async {
    emit(const AnimeDetailLoading());

    try {
      // Load anime details and trending anime concurrently
      final results = await Future.wait([
        animeRepository.getAnimeDetails(event.animeId),
        animeRepository.getTopAnime(limit: 10),
      ]);

      emit(AnimeDetailLoaded(
        anime: results[0] as Anime,
        trendingAnime: results[1] as List<Anime>,
      ));
    } catch (e) {
      emit(AnimeDetailError(e.toString()));
    }
  }
}
