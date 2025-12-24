import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:anime_hub/business_logic/search/search_event.dart';
import 'package:anime_hub/business_logic/search/search_state.dart';
import 'package:anime_hub/data/repositories/anime_repository.dart';
import 'package:anime_hub/core/constants/app_constants.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final AnimeRepository animeRepository;
  Timer? _debounce;

  SearchBloc({required this.animeRepository}) : super(const SearchInitial()) {
    on<SearchAnime>(
      _onSearchAnime,
      transformer: restartable(),
    );
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchAnime(
    SearchAnime event,
    Emitter<SearchState> emit,
  ) async {
    // Implement debouncing
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    await Future.delayed(Duration(milliseconds: AppConstants.searchDebounceMs));
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    try {
      final results = await animeRepository.searchAnime(query);

      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(results: results, query: query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
