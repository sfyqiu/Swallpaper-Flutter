import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../services/localization_service.dart';
import '../widgets/wallpaper_grid.dart';
import '../widgets/source_chips.dart';
import '../widgets/search_bar_widget.dart';

class ExploreScreen extends StatelessWidget {
  final String? sourceType;

  const ExploreScreen({super.key, this.sourceType});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('explore')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          const SourceChips(),
          Expanded(
            child: Consumer<WallpaperProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.wallpapers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null && provider.wallpapers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        FilledButton.tonalIcon(
                          onPressed: () => provider.fetchWallpapers(refresh: true),
                          icon: const Icon(Icons.refresh),
                          label: Text(loc.tr('retry')),
                        ),
                      ],
                    ),
                  );
                }

                return WallpaperGrid(
                  wallpapers: provider.wallpapers,
                  hasMore: provider.hasMore,
                  isLoading: provider.isLoading,
                  onLoadMore: () => provider.fetchWallpapers(),
                  onRefresh: () => provider.fetchWallpapers(refresh: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterSheet(),
    );
  }
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String _selectedSorting = 'date_added';
  String _selectedPurity = '100';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Text('Sort By', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildFilterChip('Date Added', 'date_added'),
              _buildFilterChip('Relevance', 'relevance'),
              _buildFilterChip('Views', 'views'),
              _buildFilterChip('Favorites', 'favorites'),
              _buildFilterChip('Top List', 'toplist'),
              _buildFilterChip('Random', 'random'),
            ],
          ),
          const SizedBox(height: 20),
          Text('Purity', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildPurityChip('SFW', '100'),
              _buildPurityChip('Sketchy', '010'),
              _buildPurityChip('NSFW', '001'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _selectedSorting == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _selectedSorting = value);
        context.read<WallpaperProvider>().fetchWallpapers(refresh: true);
      },
    );
  }

  Widget _buildPurityChip(String label, String value) {
    final selected = _selectedPurity == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _selectedPurity = value);
      },
    );
  }
}
