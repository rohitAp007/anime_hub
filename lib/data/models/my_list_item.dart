import 'package:hive/hive.dart';

part 'my_list_item.g.dart';

@HiveType(typeId: 0)
class MyListItem extends HiveObject {
  @HiveField(0)
  final int malId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterUrl;

  @HiveField(3)
  final double? score;

  @HiveField(4)
  final DateTime addedAt;

  MyListItem({
    required this.malId,
    required this.title,
    required this.posterUrl,
    this.score,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}
