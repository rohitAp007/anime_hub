import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchAnime extends SearchEvent {
  final String query;

  const SearchAnime(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}
