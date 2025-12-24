import 'package:equatable/equatable.dart';
import 'package:anime_hub/data/models/anime.dart';

abstract class MyListEvent extends Equatable {
  const MyListEvent();

  @override
  List<Object> get props => [];
}

class LoadMyList extends MyListEvent {
  const LoadMyList();
}

class AddToMyList extends MyListEvent {
  final Anime anime;

  const AddToMyList(this.anime);

  @override
  List<Object> get props => [anime];
}

class RemoveFromMyList extends MyListEvent {
  final int malId;

  const RemoveFromMyList(this.malId);

  @override
  List<Object> get props => [malId];
}

class CheckIfInMyList extends MyListEvent {
  final int malId;

  const CheckIfInMyList(this.malId);

  @override
  List<Object> get props => [malId];
}
