import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/app_state.dart';
import '../../services/localization_service.dart';
import '../../widgets/cards/wallpaper_card.dart';
import '../../widgets/common/chip_row.dart';
import '../../widgets/common/glass_search_bar.dart';

class WallpaperExploreScreen extends StatefulWidget {
  const WallpaperExploreScreen({super.key});

  @override
  State<WallpaperExploreScreen> createState() => _WallpaperExploreScreenState();
}

class _WallpaperExploreScreenState extends State<WallpaperExploreScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchWallpapers(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<AppState>().fetchWallpapers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return GlassAtmosphereBackground(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 8)),

          // Title + filter button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.tr('nav.wallpaper'), style: Theme.of(context).textTheme.headlineMedium),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: AppColors.textSecondary),
                    onPressed: () => _showFilterSheet(context),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassSearchBar(
                controller: _searchController,
                hintText: loc.tr('explore.search'),
                onSubmitted: (v) => context.read<AppState>().setSearchQuery(v),
                onClear: () => context.read<AppState>().setSearchQuery(null),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Source chips
          SliverToBoxAdapter(
            child: Consumer<AppState>(
              builder: (context, state, _) => ChipRow(
                items: state.wallpaperSources,
                selected: state.currentWallpaperSource,
                onSelected: (s) => state.setWallpaperSource(s),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Grid
          Consumer<AppState>(
            builder: (context, state, _) {
              if (state.wallpapersLoading && state.wallpapers.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
                );
              }
              if (state.wallpapersError != null && state.wallpapers.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.warningOrange),
                        const SizedBox(height: 12),
                        Text(state.wallpapersError!, style: TextStyle(color: AppColors.textTertiary)),
                        const SizedBox(height: 12),
                        GlassButton(label: loc.tr('common.retry'), onTap: () => state.fetchWallpapers(refresh: true)),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      if (i >= state.wallpapers.length) return null;
                      final wp = state.wallpapers[i];
                      return WallpaperGridCard(
                        wallpaper: wp,
                        onTap: () => _showDetail(context, wp, state),
                      );
                    },
                    childCount: state.wallpapers.length,
                  ),
                ),
              );
            },
          ),

          // Loading indicator
          Consumer<AppState>(
            builder: (context, state, _) {
              if (!state.wallpapersLoading || state.wallpapers.isEmpty) return const SliverToBoxAdapter();
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
                ),
              );
            },
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
          appBar: AppBar(title: Text(item.title.length > 30 ? '${item.title.substring(0, 30)}...' : item.title)),
          body: const Center(child: Text('Detail coming soon')),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.midBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textQuaternary, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Sort By', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                'date_added', 'relevance', 'views', 'favorites', 'toplist', 'random'
              ].map((s) => ChoiceChip(
                label: Text(s.replaceAll('_', ' ').toUpperCase()),
                selected: s == 'date_added',
                onSelected: (_) {
                  context.read<AppState>().setFilters(sorting: s);
                  Navigator.pop(ctx);
                },
              )).toList(),
            ),
            const SizedBox(height: 20),
            Text('Purity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ('100', 'SFW'), ('010', 'Sketchy'), ('001', 'NSFW'),
              ].map((e) => ChoiceChip(
                label: Text(e.$2),
                selected: e.$1 == '100',
                onSelected: (_) {
                  context.read<AppState>().setFilters(purity: e.$1);
                  Navigator.pop(ctx);
                },
              )).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
