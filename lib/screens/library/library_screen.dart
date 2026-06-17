import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/app_state.dart';
import '../../services/localization_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return GlassAtmosphereBackground(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(loc.tr('nav.library'), style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 12),

          // Tab bar (Favorites / Downloads)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.glassTint,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              tabs: [
                Tab(text: loc.tr('library.favorites')),
                Tab(text: loc.tr('library.downloads')),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _FavoritesTab(),
                _DownloadsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return Consumer<AppState>(
      builder: (context, state, _) {
        if (state.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: AppColors.textQuaternary),
                const SizedBox(height: 16),
                Text(loc.tr('library.empty'), style: TextStyle(color: AppColors.textTertiary, fontSize: 16)),
                const SizedBox(height: 8),
                Text(loc.tr('library.emptyHint'), style: TextStyle(color: AppColors.textQuaternary, fontSize: 13)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: state.favorites.length,
          itemBuilder: (_, i) {
            final fav = state.favorites[i];
            final imageUrl = fav.item is Wallpaper
                ? (fav.item as Wallpaper).thumbnailUrl
                : (fav.item as MediaItem).thumbnailUrl;
            final title = fav.item is Wallpaper
                ? (fav.item as Wallpaper).title
                : (fav.item as MediaItem).title;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.borderSubtle),
                color: AppColors.glassTint,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceBackground))
                        : Container(color: AppColors.surfaceBackground),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _DownloadsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_outlined, size: 64, color: AppColors.textQuaternary),
          const SizedBox(height: 16),
          Text(loc.tr('library.empty'), style: TextStyle(color: AppColors.textTertiary, fontSize: 16)),
        ],
      ),
    );
  }
}
