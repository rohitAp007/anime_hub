import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anime_hub/core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.movie_filter,
              size: 80,
              color: AppColors.primaryAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'Anime Hub',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Version ${snapshot.data!.version}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }
                return const Text('Version 1.0.0');
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Your companion for discovering and tracking anime. Built with Flutter and powered by Jikan API.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              context,
              icon: Icons.code,
              title: 'Technology',
              description: 'Flutter • Bloc • Hive • Jikan API',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              icon: Icons.palette,
              title: 'Design',
              description: 'Material Design 3 • Dark Theme',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              icon: Icons.api,
              title: 'Data Source',
              description: 'Jikan API (MyAnimeList)',
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => _launchURL('https://jikan.moe/'),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Visit Jikan API'),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2025 Anime Hub\nDeveloped by Rohit Parsode\nMade with ❤️ for anime enthusiasts',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryAccent, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
