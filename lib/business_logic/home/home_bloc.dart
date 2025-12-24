import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/business_logic/home/home_event.dart';
import 'package:anime_hub/business_logic/home/home_state.dart';
import 'package:anime_hub/data/repositories/anime_repository.dart';
import 'package:anime_hub/data/models/anime.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AnimeRepository animeRepository;

  HomeBloc({required this.animeRepository}) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // Load all data concurrently
      final results = await Future.wait([
        animeRepository.getRandomAnime(),
        animeRepository.getTopAnime(limit: 10),
        animeRepository.getUpcomingAnime(limit: 10),
      ]);

      emit(HomeLoaded(
        randomAnime: results[0] as Anime,
        trendingAnime: results[1] as List<Anime>,
        upcomingAnime: results[2] as List<Anime>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // Use same logic as load
    await _onLoadHomeData(const LoadHomeData(), emit);
  }
}
