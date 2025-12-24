import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/business_logic/search/search_bloc.dart';
import 'package:anime_hub/business_logic/search/search_event.dart';
import 'package:anime_hub/business_logic/search/search_state.dart';
import 'package:anime_hub/presentation/widgets/anime_grid_item.dart';
import 'package:anime_hub/core/widgets/loading_shimmer.dart';
import 'package:anime_hub/core/widgets/error_widget.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/core/constants/app_colors.dart';
import 'package:anime_hub/presentation/screens/detail/anime_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Anime',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchAnime(query));
                },
              ),
            ),
            // Results
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Popular Searches',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildSuggestionChip(context, 'Naruto'),
                                _buildSuggestionChip(context, 'One Piece'),
                                _buildSuggestionChip(context, 'Attack on Titan'),
                                _buildSuggestionChip(context, 'Demon Slayer'),
                                _buildSuggestionChip(context, 'My Hero Academia'),
                                _buildSuggestionChip(context, 'Death Note'),
                                _buildSuggestionChip(context, 'Jujutsu Kaisen'),
                                _buildSuggestionChip(context, 'Dragon Ball'),
                                _buildSuggestionChip(context, 'Tokyo Ghoul'),
                                _buildSuggestionChip(context, 'Sword Art Online'),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Search for your favorite anime',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SearchLoading) {
                    return const GridShimmer();
                  } else if (state is SearchLoaded) {
                    return _buildResults(state.results);
                  } else if (state is SearchEmpty) {
                    return EmptyStateWidget(
                      message: 'No results found for "${state.query}"',
                      icon: Icons.search_off,
                    );
                  } else if (state is SearchError) {
                    return ErrorDisplayWidget(
                      message: state.message,
                      onRetry: () {
                        if (_searchController.text.isNotEmpty) {
                          context.read<SearchBloc>().add(
                                SearchAnime(_searchController.text),
                              );
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String query) {
    return ActionChip(
      label: Text(query),
      onPressed: () {
        _searchController.text = query;
        context.read<SearchBloc>().add(SearchAnime(query));
      },
      backgroundColor: AppColors.cardBackground,
      labelStyle: TextStyle(color: AppColors.textPrimary),
      side: BorderSide(color: AppColors.textSecondary, width: 0.5),
    );
  }

  Widget _buildResults(List results) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppConstants.gridGap,
        mainAxisSpacing: AppConstants.gridGap,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return AnimeGridItem(
          anime: results[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnimeDetailScreen(
                  animeId: results[index].malId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
