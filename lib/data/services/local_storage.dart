import 'package:hive_flutter/hive_flutter.dart';
import 'package:anime_hub/data/models/my_list_item.dart';
import 'package:anime_hub/core/constants/app_constants.dart';

class LocalStorageService {
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MyListItemAdapter());
    }

    // Open boxes
    await Hive.openBox<MyListItem>(AppConstants.myListBox);
  }

  static Box<MyListItem> get myListBox =>
      Hive.box<MyListItem>(AppConstants.myListBox);

  static Future<void> close() async {
    await Hive.close();
  }
}
