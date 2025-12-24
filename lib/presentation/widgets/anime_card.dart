import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/core/widgets/rating_badge.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;
  final bool showRating;

  const AnimeCard({
    super.key,
    required this.anime,
    required this.onTap,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.animeCardWidth,
        margin: const EdgeInsets.only(right: AppConstants.cardSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image with Rating Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.cardBorderRadius,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: anime.posterUrl,
                    width: AppConstants.animeCardWidth,
                    height: AppConstants.animeCardHeight,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: AppConstants.animeCardWidth,
                      height: AppConstants.animeCardHeight,
                      color: AppColors.cardBackground,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: AppConstants.animeCardWidth,
                      height: AppConstants.animeCardHeight,
                      color: AppColors.cardBackground,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.textSecondary,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                if (showRating && anime.score != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: RatingBadge(rating: anime.score!),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              anime.displayTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
