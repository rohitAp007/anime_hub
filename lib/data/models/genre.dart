import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int malId;
  final String type;
  final String name;
  final String url;

  const Genre({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      malId: json['mal_id'] as int,
      type: json['type'] as String? ?? 'anime',
      name: json['name'] as String,
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'type': type,
      'name': name,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [malId, type, name, url];
}
