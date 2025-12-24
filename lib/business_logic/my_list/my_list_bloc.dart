import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/business_logic/my_list/my_list_event.dart';
import 'package:anime_hub/business_logic/my_list/my_list_state.dart';
import 'package:anime_hub/data/repositories/my_list_repository.dart';

class MyListBloc extends Bloc<MyListEvent, MyListState> {
  final MyListRepository myListRepository;

  MyListBloc({required this.myListRepository}) : super(const MyListInitial()) {
    on<LoadMyList>(_onLoadMyList);
    on<AddToMyList>(_onAddToMyList);
    on<RemoveFromMyList>(_onRemoveFromMyList);
  }

  Future<void> _onLoadMyList(
    LoadMyList event,
    Emitter<MyListState> emit,
  ) async {
    try {
      final items = myListRepository.getMyList();
      final itemIds = items.map((item) => item.malId).toSet();
      
      emit(MyListLoaded(items: items, itemIds: itemIds));
    } catch (e) {
      emit(MyListError(e.toString()));
    }
  }

  Future<void> _onAddToMyList(
    AddToMyList event,
    Emitter<MyListState> emit,
  ) async {
    try {
      await myListRepository.addToMyList(event.anime);
      // Reload list
      add(const LoadMyList());
    } catch (e) {
      emit(MyListError(e.toString()));
    }
  }

  Future<void> _onRemoveFromMyList(
    RemoveFromMyList event,
    Emitter<MyListState> emit,
  ) async {
    try {
      await myListRepository.removeFromMyList(event.malId);
      // Reload list
      add(const LoadMyList());
    } catch (e) {
      emit(MyListError(e.toString()));
    }
  }
}
