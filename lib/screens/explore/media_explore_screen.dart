import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/app_state.dart';
import '../../services/localization_service.dart';
import '../../widgets/common/chip_row.dart';

class MediaExploreScreen extends StatefulWidget {
  const MediaExploreScreen({super.key});

  @override
  State<MediaExploreScreen> createState() => _MediaExploreScreenState();
}

class _MediaExploreScreenState extends State<MediaExploreScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchMedia(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<AppState>().fetchMedia();
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(loc.tr('nav.media'), style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),

          // Source chips
          SliverToBoxAdapter(
            child: Consumer<AppState>(
              builder: (context, state, _) => ChipRow(
                items: state.mediaSources,
                selected: state.currentMediaSource,
                onSelected: (s) => state.setMediaSource(s),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Media grid
          Consumer<AppState>(
            builder: (context, state, _) {
              if (state.mediaLoading && state.mediaItems.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryPink)),
                );
              }
              if (state.mediaError != null && state.mediaItems.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: AppColors.warningOrange),
                        const SizedBox(height: 12),
                        Text(state.mediaError!, style: TextStyle(color: AppColors.textTertiary)),
                        const SizedBox(height: 12),
                        GlassButton(label: loc.tr('common.retry'), onTap: () => state.fetchMedia(refresh: true)),
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
                      if (i >= state.mediaItems.length) return null;
                      final media = state.mediaItems[i];
                      return _MediaGridCard(media: media);
                    },
                    childCount: state.mediaItems.length,
                  ),
                ),
              );
            },
          ),

          Consumer<AppState>(
            builder: (context, state, _) {
              if (!state.mediaLoading || state.mediaItems.isEmpty) return const SliverToBoxAdapter();
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
}

class _MediaGridCard extends StatelessWidget {
  final dynamic media;
  const _MediaGridCard({required this.media});

  @override
  Widget build(BuildContext context) {
    final imageUrl = media.thumbnailUrl;
    final title = media.title;
    final source = media.source;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.borderSubtle),
          color: AppColors.glassTint,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceBackground)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                      ),
                    ),
                  ),
                  const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48)),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(source, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
