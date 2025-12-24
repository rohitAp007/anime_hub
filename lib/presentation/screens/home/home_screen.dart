import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anime_hub/business_logic/home/home_bloc.dart';
import 'package:anime_hub/business_logic/home/home_event.dart';
import 'package:anime_hub/business_logic/home/home_state.dart';
import 'package:anime_hub/business_logic/my_list/my_list_bloc.dart';
import 'package:anime_hub/business_logic/my_list/my_list_event.dart';
import 'package:anime_hub/business_logic/my_list/my_list_state.dart';
import 'package:anime_hub/presentation/widgets/anime_card.dart';
import 'package:anime_hub/core/widgets/loading_shimmer.dart';
import 'package:anime_hub/core/widgets/error_widget.dart';
import 'package:anime_hub/core/widgets/section_header.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/data/models/anime.dart';
import 'package:anime_hub/presentation/screens/detail/anime_detail_screen.dart';
import 'package:anime_hub/presentation/screens/view_all/view_all_screen.dart';
import 'package:anime_hub/presentation/navigation/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoading();
          } else if (state is HomeLoaded) {
            return _buildLoaded(state);
          } else if (state is HomeError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<HomeBloc>().add(const LoadHomeData());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeroShimmer(),
          const SizedBox(height: 24),
          _buildShimmerSection(),
          const SizedBox(height: 24),
          _buildShimmerSection(),
        ],
      ),
    );
  }

  Widget _buildShimmerSection() {
    return Column(
      children: [
        const SectionHeader(title: 'Loading...'),
        SizedBox(
          height: AppConstants.animeCardHeight + 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
            itemCount: 5,
            itemBuilder: (context, index) => const CardShimmer(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoaded(HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHomeData());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(state.randomAnime),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Trending Anime',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllScreen(
                      title: 'Trending Anime',
                      type: 'trending',
                    ),
                  ),
                );
              },
            ),
            _buildAnimeList(state.trendingAnime),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Upcoming Anime',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllScreen(
                      title: 'Upcoming Anime',
                      type: 'upcoming',
                    ),
                  ),
                );
              },
            ),
            _buildAnimeList(state.upcomingAnime),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Anime anime) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(AppConstants.screenPadding),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            child: CachedNetworkImage(
              imageUrl: anime.posterUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.displayTitle,
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    anime.shortSynopsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (anime.hasTrailer) {
                              _launchTrailer(anime.trailer!.youtubeUrl!);
                            } else {
                              _navigateToDetail(anime);
                            }
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BlocBuilder<MyListBloc, MyListState>(
                          builder: (context, myListState) {
                            final isInList = myListState is MyListLoaded &&
                                myListState.isInList(anime.malId);
                            
                            return OutlinedButton.icon(
                              onPressed: () {
                                if (isInList) {
                                  context.read<MyListBloc>().add(RemoveFromMyList(anime.malId));
                                } else {
                                  context.read<MyListBloc>().add(AddToMyList(anime));
                                }
                              },
                              icon: Icon(isInList ? Icons.check : Icons.add),
                              label: const Text('My List'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeList(List<Anime> animeList) {
    return SizedBox(
      height: AppConstants.animeCardHeight + 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          return AnimeCard(
            anime: animeList[index],
            onTap: () => _navigateToDetail(animeList[index]),
          );
        },
      ),
    );
  }

  void _navigateToDetail(Anime anime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimeDetailScreen(animeId: anime.malId),
      ),
    );
  }

  Future<void> _launchTrailer(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
