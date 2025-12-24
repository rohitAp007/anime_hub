import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:anime_hub/business_logic/anime_detail/anime_detail_bloc.dart';
import 'package:anime_hub/business_logic/anime_detail/anime_detail_event.dart';
import 'package:anime_hub/business_logic/anime_detail/anime_detail_state.dart';
import 'package:anime_hub/presentation/widgets/anime_card.dart';
import 'package:anime_hub/core/widgets/error_widget.dart';
import 'package:anime_hub/core/widgets/section_header.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/data/repositories/anime_repository.dart';

class AnimeDetailScreen extends StatelessWidget {
  final int animeId;

  const AnimeDetailScreen({
    super.key,
    required this.animeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimeDetailBloc(
        animeRepository: context.read<AnimeRepository>(),
      )..add(LoadAnimeDetail(animeId)),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
              builder: (context, state) {
                if (state is AnimeDetailLoaded) {
                  return IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareAnime(state.anime),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
          builder: (context, state) {
            if (state is AnimeDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnimeDetailLoaded) {
              return _buildDetail(context, state.anime, state.trendingAnime);
            } else if (state is AnimeDetailError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () {
                  context.read<AnimeDetailBloc>().add(LoadAnimeDetail(animeId));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Anime anime, List<Anime> trending) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        SliverAppBar(
          expandedHeight: 350,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                CachedNetworkImage(
                  imageUrl: anime.posterUrl,
                  fit: BoxFit.cover,
                ),
                // Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Small Poster
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: anime.posterUrl,
                            width: 100,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                anime.displayTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'year: ${anime.yearText}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Anime Rating ${anime.scoreText}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                anime.genresText,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Play Trailer Button - Always visible
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _launchTrailer(anime),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.play_circle_filled, size: 28),
                  label: const Text(
                    'Play Trailer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Synopsis
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anime Synopsis',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anime.synopsis ?? 'No synopsis available.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Trending Anime
              SectionHeader(
                title: 'Trending Anime',
                onViewAll: () {},
              ),
              SizedBox(
                height: AppConstants.animeCardHeight + 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding,
                  ),
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return AnimeCard(
                      anime: trending[index],
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeDetailScreen(
                              animeId: trending[index].malId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchTrailer(Anime anime) async {
    try {
      String url;
      
      // Check if we have a valid YouTube trailer
      if (anime.trailer != null && 
          anime.trailer!.youtubeId != null && 
          anime.trailer!.youtubeId!.isNotEmpty) {
        // Use YouTube ID to create direct video link
        final youtubeId = anime.trailer!.youtubeId!;
        // This format works best on mobile - opens in YouTube app if installed
        url = 'https://www.youtube.com/watch?v=$youtubeId';
        print('▶️ Opening trailer: $url');
      } else {
        // No trailer available - create a YouTube search URL that opens the app
        final searchQuery = Uri.encodeComponent(anime.displayTitle);
        // YouTube mobile app search URL format
        url = 'https://m.youtube.com/results?search_query=$searchQuery+anime+trailer';
        print('🔍 Searching YouTube: ${anime.displayTitle}');
      }
      
      final uri = Uri.parse(url);
      
      // Use external app mode to open YouTube
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        print('✅ Launched successfully');
      } else {
        print('❌ Cannot launch URL: $url');
        // Fallback: try with platform default
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      print('❌ Failed to launch trailer: $e');
    }
  }

  void _shareAnime(Anime anime) {
    final text = '''
Check out ${anime.displayTitle}!

${anime.score != null ? '⭐ Rating: ${anime.scoreText}/10' : ''}
${anime.yearText} • ${anime.genresText}

${anime.synopsis != null && anime.synopsis!.length > 150 ? '${anime.synopsis!.substring(0, 150)}...' : anime.synopsis ?? ''}

Learn more: https://myanimelist.net/anime/${anime.malId}
''';
    Share.share(text, subject: anime.displayTitle);
  }
}
