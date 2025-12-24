import 'package:equatable/equatable.dart';

class AnimeImages extends Equatable {
  final ImageUrls jpg;
  final ImageUrls webp;

  const AnimeImages({
    required this.jpg,
    required this.webp,
  });

  factory AnimeImages.fromJson(Map<String, dynamic> json) {
    return AnimeImages(
      jpg: ImageUrls.fromJson(json['jpg'] ?? {}),
      webp: ImageUrls.fromJson(json['webp'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jpg': jpg.toJson(),
      'webp': webp.toJson(),
    };
  }

  @override
  List<Object?> get props => [jpg, webp];
}

class ImageUrls extends Equatable {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? largeImageUrl;

  const ImageUrls({
    this.imageUrl,
    this.smallImageUrl,
    this.largeImageUrl,
  });

  factory ImageUrls.fromJson(Map<String, dynamic> json) {
    return ImageUrls(
      imageUrl: json['image_url'] as String?,
      smallImageUrl: json['small_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'small_image_url': smallImageUrl,
      'large_image_url': largeImageUrl,
    };
  }

  @override
  List<Object?> get props => [imageUrl, smallImageUrl, largeImageUrl];
}
