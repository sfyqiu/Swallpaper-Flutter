import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/wallpaper.dart';
import '../screens/wallpaper_detail_screen.dart';

class WallpaperGrid extends StatelessWidget {
  final List<Wallpaper> wallpapers;
  final bool hasMore;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRefresh;

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    this.hasMore = false,
    this.isLoading = false,
    this.onLoadMore,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (wallpapers.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No wallpapers found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              hasMore &&
              !isLoading &&
              onLoadMore != null) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              onLoadMore!();
            }
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverMasonryGrid(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final wallpaper = wallpapers[index];
                    return WallpaperCard(
                      wallpaper: wallpaper,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WallpaperDetailScreen(
                              wallpaperId: wallpaper.id,
                              source: wallpaper.source,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: wallpapers.length,
                ),
              ),
            ),
            if (isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WallpaperCard extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback? onTap;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: wallpaper.aspectRatio,
          child: CachedNetworkImage(
            imageUrl: wallpaper.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              highlightColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
      ),
    );
  }
}
