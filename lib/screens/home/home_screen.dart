import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/localization_service.dart';
import '../explore/wallpaper_explore_screen.dart';
import '../explore/media_explore_screen.dart';
import '../library/library_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    WallpaperExploreScreen(),
    MediaExploreScreen(),
    LibraryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);
    final navLabels = [
      loc.tr('nav.home'), loc.tr('nav.wallpaper'), loc.tr('nav.media'),
      loc.tr('nav.library'), loc.tr('nav.settings'),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.midBackground,
        elevation: 0,
        indicatorColor: AppColors.primaryPink.withValues(alpha: 0.2),
        height: 65,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined, color: AppColors.textTertiary), selectedIcon: const Icon(Icons.home, color: AppColors.primaryPink), label: navLabels[0]),
          NavigationDestination(icon: Icon(Icons.photo_outlined, color: AppColors.textTertiary), selectedIcon: const Icon(Icons.photo, color: AppColors.primaryPink), label: navLabels[1]),
          NavigationDestination(icon: Icon(Icons.play_circle_outlined, color: AppColors.textTertiary), selectedIcon: const Icon(Icons.play_circle, color: AppColors.primaryPink), label: navLabels[2]),
          NavigationDestination(icon: Icon(Icons.favorite_outline, color: AppColors.textTertiary), selectedIcon: const Icon(Icons.favorite, color: AppColors.primaryPink), label: navLabels[3]),
          NavigationDestination(icon: Icon(Icons.settings_outlined, color: AppColors.textTertiary), selectedIcon: const Icon(Icons.settings, color: AppColors.primaryPink), label: navLabels[4]),
        ],
      ),
    );
  }
}

/// Home tab with hero carousel and content shelves
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final PageController _heroController = PageController();
  int _currentHeroPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchHomeContent();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return GlassAtmosphereBackground(
      child: CustomScrollView(
        slivers: [
          // Hero carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 420,
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  if (state.homeLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
                  }
                  final items = [...state.homeWallpapers.take(5), ...state.homeMedia.take(3)];
                  if (items.isEmpty) return const SizedBox();

                  return Stack(
                    children: [
                      PageView.builder(
                        controller: _heroController,
                        onPageChanged: (i) => setState(() => _currentHeroPage = i),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final item = items[i];
                          return _HeroCard(item: item);
                        },
                      ),
                      // Hero overlay gradient + text
                      Positioned(
                        left: 24, right: 24, bottom: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.tr('home.hero.title'),
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 34, fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.tr('home.hero.subtitle'),
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Pagination dots
                      Positioned(
                        left: 24, bottom: 24,
                        child: Row(
                          children: List.generate(items.length, (i) =>
                            Container(
                              width: i == _currentHeroPage ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: i == _currentHeroPage
                                    ? AppColors.primaryPink
                                    : AppColors.textTertiary.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Shuffle button
                      Positioned(
                        right: 20, bottom: 16,
                        child: IconButton(
                          icon: Icon(Icons.shuffle, color: AppColors.textSecondary, size: 22),
                          onPressed: () {
                            final next = (_currentHeroPage + 1) % items.length;
                            _heroController.animateToPage(next, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Guess You Like section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.tr('home.guessYouLike'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                  TextButton(
                    onPressed: () {},
                    child: Text(loc.tr('home.viewAll'), style: TextStyle(color: AppColors.primaryPink, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  if (state.homeWallpapers.isEmpty) return const SizedBox();
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.homeWallpapers.take(10).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final wp = state.homeWallpapers[i];
                      return _ShelfCard(
                        imageUrl: wp.thumbnailUrl,
                        title: wp.title,
                        subtitle: wp.source,
                        onTap: () => _showDetail(context, wp, state),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Trending Media section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.tr('home.trendingMedia'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                  TextButton(
                    onPressed: () {},
                    child: Text(loc.tr('home.viewAll'), style: TextStyle(color: AppColors.primaryPink, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  if (state.homeMedia.isEmpty) return const SizedBox();
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.homeMedia.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final media = state.homeMedia[i];
                      return _ShelfCard(
                        imageUrl: media.thumbnailUrl,
                        title: media.title,
                        subtitle: media.source,
                        isVideo: true,
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, dynamic item, AppState state) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(item is Wallpaper ? item.title : 'Detail')),
          body: const Center(child: Text('Detail view')),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final dynamic item;
  const _HeroCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item is Wallpaper ? (item as Wallpaper).url : (item as MediaItem).thumbnailUrl;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.7)],
        ),
        image: imageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.deepBackground.withValues(alpha: 0.6)],
          ),
        ),
      ),
    );
  }
}

class _ShelfCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool isVideo;
  final VoidCallback? onTap;

  const _ShelfCard({
    required this.imageUrl, required this.title, required this.subtitle,
    this.isVideo = false, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.borderSubtle),
          image: imageUrl.isNotEmpty
              ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
              : null,
          color: AppColors.glassTint,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter, end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isVideo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('VIDEO', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 11), maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}
