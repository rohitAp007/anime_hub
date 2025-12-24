import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime_hub/core/theme/app_theme.dart';
import 'package:anime_hub/data/services/local_storage.dart';
import 'package:anime_hub/data/services/api_service.dart';
import 'package:anime_hub/data/repositories/anime_repository.dart';
import 'package:anime_hub/data/repositories/my_list_repository.dart';
import 'package:anime_hub/business_logic/theme/theme_bloc.dart';
import 'package:anime_hub/business_logic/theme/theme_event.dart';
import 'package:anime_hub/business_logic/theme/theme_state.dart';
import 'package:anime_hub/business_logic/home/home_bloc.dart';
import 'package:anime_hub/business_logic/search/search_bloc.dart';
import 'package:anime_hub/business_logic/my_list/my_list_bloc.dart';
import 'package:anime_hub/business_logic/my_list/my_list_event.dart';
import 'package:anime_hub/presentation/screens/home/home_screen.dart';
import 'package:anime_hub/presentation/screens/search/search_screen.dart';
import 'package:anime_hub/presentation/screens/new_releases/new_releases_screen.dart';
import 'package:anime_hub/presentation/screens/my_list/my_list_screen.dart';
import 'package:anime_hub/presentation/screens/settings/settings_screen.dart';
import 'package:anime_hub/presentation/screens/about/about_screen.dart';
import 'package:anime_hub/presentation/navigation/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await LocalStorageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ApiService(),
        ),
        RepositoryProvider(
          create: (context) => AnimeRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MyListRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc()..add(const LoadTheme()),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              animeRepository: context.read<AnimeRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchBloc(
              animeRepository: context.read<AnimeRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => MyListBloc(
              myListRepository: context.read<MyListRepository>(),
            )..add(const LoadMyList()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Anime Hub',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: const MainScreen(),
              routes: {
                '/my-list': (context) => const MyListScreen(),
                '/settings': (context) => const SettingsScreen(),
                '/about': (context) => const AboutScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    NewReleasesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
