import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_hub/business_logic/my_list/my_list_bloc.dart';
import 'package:anime_hub/business_logic/my_list/my_list_state.dart';
import 'package:anime_hub/business_logic/my_list/my_list_event.dart';
import 'package:anime_hub/core/widgets/error_widget.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/presentation/screens/detail/anime_detail_screen.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List'),
        actions: [
          BlocBuilder<MyListBloc, MyListState>(
            builder: (context, state) {
              if (state is MyListLoaded && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    _showClearDialog(context);
                  },
                  tooltip: 'Clear all',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<MyListBloc, MyListState>(
        builder: (context, state) {
          if (state is MyListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyListLoaded) {
            if (state.items.isEmpty) {
              return const EmptyStateWidget(
                message: 'Your list is empty\nStart adding your favorite anime!',
                icon: Icons.favorite_border,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.posterUrl,
                        width: 60,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 80,
                          color: AppColors.cardBackground,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 80,
                          color: AppColors.cardBackground,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    title: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (item.score != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.ratingBadge,
                              ),
                              const SizedBox(width: 4),
                              Text(item.score!.toStringAsFixed(1)),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'Added ${_formatDate(item.addedAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.primaryAccent,
                      ),
                      onPressed: () {
                        context.read<MyListBloc>().add(RemoveFromMyList(item.malId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} removed from list'),
                            backgroundColor: AppColors.cardBackground,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimeDetailScreen(
                            animeId: item.malId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is MyListError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<MyListBloc>().add(const LoadMyList());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Clear My List'),
        content: const Text('Are you sure you want to remove all anime from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MyListBloc>().add(const LoadMyList());
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My List cleared'),
                  backgroundColor: AppColors.cardBackground,
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
