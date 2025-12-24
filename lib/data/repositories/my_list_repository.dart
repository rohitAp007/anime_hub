import 'package:anime_hub/data/models/my_list_item.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/data/services/local_storage.dart';

class MyListRepository {
  /// Add anime to My List
  Future<void> addToMyList(Anime anime) async {
    final box = LocalStorageService.myListBox;
    
    final item = MyListItem(
      malId: anime.malId,
      title: anime.displayTitle,
      posterUrl: anime.posterUrl,
      score: anime.score,
    );

    await box.put(anime.malId, item);
  }

  /// Remove anime from My List
  Future<void> removeFromMyList(int malId) async {
    final box = LocalStorageService.myListBox;
    await box.delete(malId);
  }

  /// Check if anime is in My List
  bool isInMyList(int malId) {
    final box = LocalStorageService.myListBox;
    return box.containsKey(malId);
  }

  /// Get all anime from My List
  List<MyListItem> getMyList() {
    final box = LocalStorageService.myListBox;
    return box.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Sort by date, newest first
  }

  /// Get My List count
  int getMyListCount() {
    final box = LocalStorageService.myListBox;
    return box.length;
  }

  /// Clear all from My List
  Future<void> clearMyList() async {
    final box = LocalStorageService.myListBox;
    await box.clear();
  }
}
