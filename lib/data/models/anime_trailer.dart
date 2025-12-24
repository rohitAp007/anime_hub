import 'package:equatable/equatable.dart';

class AnimeTrailer extends Equatable {
  final String? youtubeId;
  final String? url;
  final String? embedUrl;

  const AnimeTrailer({
    this.youtubeId,
    this.url,
    this.embedUrl,
  });

  factory AnimeTrailer.fromJson(Map<String, dynamic> json) {
    return AnimeTrailer(
      youtubeId: json['youtube_id'] as String?,
      url: json['url'] as String?,
      embedUrl: json['embed_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'youtube_id': youtubeId,
      'url': url,
      'embed_url': embedUrl,
    };
  }

  bool get hasTrailer => youtubeId != null && youtubeId!.isNotEmpty;

  String? get youtubeUrl => youtubeId != null 
      ? 'https://www.youtube.com/watch?v=$youtubeId'
      : url;

  @override
  List<Object?> get props => [youtubeId, url, embedUrl];
}
