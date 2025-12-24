import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/core/constants/app_constants.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBackground,
      highlightColor: AppColors.searchBarBackground,
      child: Container(
        width: AppConstants.animeCardWidth,
        height: AppConstants.animeCardHeight,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
      ),
    );
  }
}

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppConstants.gridGap,
        mainAxisSpacing: AppConstants.gridGap,
      ),
      itemCount: AppConstants.shimmerGridCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.cardBackground,
          highlightColor: AppColors.searchBarBackground,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
          ),
        );
      },
    );
  }
}

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.cardBackground,
          highlightColor: AppColors.searchBarBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppConstants.posterThumbnailWidth,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: AppColors.cardBackground,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 14,
                      color: AppColors.cardBackground,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: AppColors.cardBackground,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: AppColors.cardBackground,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HeroShimmer extends StatelessWidget {
  const HeroShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBackground,
      highlightColor: AppColors.searchBarBackground,
      child: Container(
        height: 300,
        width: double.infinity,
        margin: const EdgeInsets.all(AppConstants.screenPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
      ),
    );
  }
}
