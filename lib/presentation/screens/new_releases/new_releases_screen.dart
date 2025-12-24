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

class NewReleasesScreen extends StatefulWidget {
  const NewReleasesScreen({super.key});

  @override
  State<NewReleasesScreen> createState() => _NewReleasesScreenState();
}

class _NewReleasesScreenState extends State<NewReleasesScreen> {
  @override
  void initState() {
    super.initState();
    // Reuse home bloc's upcoming anime data
    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) {
      context.read<HomeBloc>().add(const LoadHomeData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Text(
                'New Releases',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const ListShimmer();
                  } else if (state is HomeLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.screenPadding,
                      ),
                      itemCount: state.upcomingAnime.length,
                      itemBuilder: (context, index) {
                        return AnimeListItem(
                          anime: state.upcomingAnime[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeDetailScreen(
                                  animeId: state.upcomingAnime[index].malId,
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
            ),
          ],
        ),
      ),
    );
  }
}
