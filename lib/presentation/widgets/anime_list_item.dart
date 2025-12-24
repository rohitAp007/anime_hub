import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/core/constants/app_colors.dart';

class AnimeListItem extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;

  const AnimeListItem({
    super.key,
    required this.anime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: anime.posterUrl,
                width: AppConstants.posterThumbnailWidth,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: AppConstants.posterThumbnailWidth,
                  height: 120,
                  color: AppColors.backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: AppConstants.posterThumbnailWidth,
                  height: 120,
                  color: AppColors.backgroundColor,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.displayTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Releases Date:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    anime.airedFrom != null
                        ? anime.airedFrom!.split('T')[0]
                        : 'TBA',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    anime.shortSynopsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
