import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/app_state.dart';
import '../../services/localization_service.dart';

class WallpaperDetailScreen extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailScreen({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);
    final state = context.watch<AppState>();
    final isFav = state.isFavorite(wallpaper.id);

    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: CustomScrollView(
        slivers: [
          // AppBar with image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppColors.deepBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (wallpaper.url.isNotEmpty)
                    Image.network(wallpaper.url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceBackground)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: [AppColors.deepBackground, Colors.transparent, Colors.transparent, AppColors.deepBackground.withValues(alpha: 0.5)],
                      ),
                    ),
                  ),
                  // Image info overlay
                  Positioned(
                    left: 20, right: 20, bottom: 16,
                    child: Row(
                      children: [
                        _Badge(label: wallpaper.source),
                        const SizedBox(width: 8),
                        _Badge(label: wallpaper.res),
                        if (wallpaper.purity.isNotEmpty) ...[const SizedBox(width: 8), _Badge(label: wallpaper.purity.toUpperCase(), color: wallpaper.purity == 'sfw' ? AppColors.onlineGreen : AppColors.warningOrange)],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? AppColors.primaryPink : AppColors.textSecondary),
                onPressed: () => state.toggleFavorite(wallpaper, 'wallpaper'),
              ),
              IconButton(icon: Icon(Icons.ios_share, color: AppColors.textSecondary), onPressed: () {}),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(wallpaper.title.isNotEmpty ? wallpaper.title : 'Untitled', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),

                  // Tags
                  if (wallpaper.tags.isNotEmpty) ...[
                    Text(loc.tr('detail.tags'), style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 4,
                      children: wallpaper.tags.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.glassTint,
                          borderRadius: BorderRadius.circular(AppRadius.capsule),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Text(t, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Info rows
                  _InfoRow(icon: Icons.person, label: loc.tr('detail.author'), value: wallpaper.author ?? 'Unknown'),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.aspect_ratio, label: loc.tr('detail.resolution'), value: wallpaper.res),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.storage, label: loc.tr('detail.fileSize'), value: _formatSize(wallpaper.fileSize)),
                  if (wallpaper.pageUrl != null) ...[
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.link, label: loc.tr('detail.source'), value: wallpaper.pageUrl!, isLink: true),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.midBackground,
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GlassButton(
                  label: loc.tr('detail.download'),
                  icon: Icons.download,
                  color: AppColors.primaryPink.withValues(alpha: 0.3),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.tr('download.start'))));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassButton(
                  label: loc.tr('detail.setWallpaper'),
                  icon: Icons.wallpaper,
                  color: AppColors.tertiaryBlue.withValues(alpha: 0.3),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Setting wallpaper...')));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return 'Unknown';
    final mb = bytes / 1024 / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class MediaDetailScreen extends StatelessWidget {
  final MediaItem media;

  const MediaDetailScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.deepBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (media.thumbnailUrl.isNotEmpty)
                    Image.network(media.thumbnailUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceBackground)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, end: Alignment.topCenter,
                        colors: [AppColors.deepBackground, Colors.transparent],
                      ),
                    ),
                  ),
                  const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 72)),
                ],
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.favorite_border, color: AppColors.textSecondary), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(media.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(children: [
                    _Badge(label: media.source),
                    const SizedBox(width: 8),
                    _Badge(label: 'VIDEO', color: AppColors.primaryPink),
                    if (media.duration != null) ...[const SizedBox(width: 8), _Badge(label: '${media.duration! ~/ 60}:${(media.duration! % 60).toString().padLeft(2, '0')}')],
                  ]),
                  const SizedBox(height: 16),
                  if (media.author != null) _InfoRow(icon: Icons.person, label: loc.tr('detail.author'), value: media.author!),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.aspect_ratio, label: loc.tr('detail.resolution'), value: '${media.width}x${media.height}'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.midBackground,
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GlassButton(label: loc.tr('detail.download'), icon: Icons.download, color: AppColors.primaryPink.withValues(alpha: 0.3), onTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shared components
class _Badge extends StatelessWidget {
  final String label;
  final Color? color;
  const _Badge({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppColors.primaryPink).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: (color ?? AppColors.primaryPink).withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(color: color ?? AppColors.primaryPink, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;

  const _InfoRow({required this.icon, required this.label, required this.value, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
        Expanded(
          child: Text(value, style: TextStyle(
            color: isLink ? AppColors.accentCyan : AppColors.textSecondary,
            fontSize: 13,
            decoration: isLink ? TextDecoration.underline : null,
          ), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
