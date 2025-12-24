import 'package:equatable/equatable.dart';
import 'package:anime_hub/data/models/my_list_item.dart';

abstract class MyListState extends Equatable {
  const MyListState();

  @override
  List<Object?> get props => [];
}

class MyListInitial extends MyListState {
  const MyListInitial();
}

class MyListLoading extends MyListState {
  const MyListLoading();
}

class MyListLoaded extends MyListState {
  final List<MyListItem> items;
  final Set<int> itemIds; // For quick lookup

  const MyListLoaded({
    required this.items,
    required this.itemIds,
  });

  bool isInList(int malId) => itemIds.contains(malId);

  @override
  List<Object?> get props => [items, itemIds];
}

class MyListError extends MyListState {
  final String message;

  const MyListError(this.message);

  @override
  List<Object?> get props => [message];
}
