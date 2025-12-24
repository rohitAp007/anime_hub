import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/core/constants/app_constants.dart';

class AnimeGridItem extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;

  const AnimeGridItem({
    super.key,
    required this.anime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              child: CachedNetworkImage(
                imageUrl: anime.posterUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.cardBackground,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.cardBackground,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            anime.displayTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
