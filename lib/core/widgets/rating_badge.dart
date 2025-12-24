import 'package:flutter/material.dart';
import 'package:anime_hub/core/constants/app_colors.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBadge({
    super.key,
    required this.rating,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.25,
        vertical: size * 0.15,
      ),
      decoration: BoxDecoration(
        color: AppColors.ratingBadge,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: size * 0.4,
          ),
          SizedBox(width: size * 0.1),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
