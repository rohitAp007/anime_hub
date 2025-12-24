import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/business_logic/home/home_bloc.dart';
import 'package:anime_hub/business_logic/home/home_event.dart';
import 'package:anime_hub/business_logic/home/home_state.dart';
import 'package:anime_hub/presentation/widgets/anime_list_item.dart';
import 'package:anime_hub/core/widgets/loading_shimmer.dart';
import 'package:anime_hub/core/widgets/error_widget.dart';
import 'package:anime_hub/core/constants/app_constants.dart';
import 'package:anime_hub/presentation/screens/detail/anime_detail_screen.dart';

class ViewAllScreen extends StatefulWidget {
  final String title;
  final String type; // 'trending' or 'upcoming'

  const ViewAllScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  void initState() {
    super.initState();
    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) {
      context.read<HomeBloc>().add(const LoadHomeData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const ListShimmer();
          } else if (state is HomeLoaded) {
            final animeList = widget.type == 'trending'
                ? state.trendingAnime
                : state.upcomingAnime;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
                vertical: 12,
              ),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                return AnimeListItem(
                  anime: animeList[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailScreen(
                          animeId: animeList[index].malId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
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
}
