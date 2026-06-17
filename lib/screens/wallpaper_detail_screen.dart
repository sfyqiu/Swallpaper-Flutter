import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/wallpaper.dart';
import '../providers/wallpaper_provider.dart';
import '../services/download_service.dart';
import '../services/wallpaper_service.dart';
import '../services/localization_service.dart';

class WallpaperDetailScreen extends StatelessWidget {
  final String wallpaperId;
  final String source;

  const WallpaperDetailScreen({
    super.key,
    required this.wallpaperId,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);
    final provider = context.watch<WallpaperProvider>();
    final wallpaper = provider.wallpapers.firstWhere(
      (w) => w.id == wallpaperId,
      orElse: () => provider.favorites.firstWhere(
        (w) => w.id == wallpaperId,
        orElse: () => Wallpaper(
          id: wallpaperId,
          source: source,
          title: 'Unknown',
          url: '',
          thumbnailUrl: '',
        ),
      ),
    );

    final isFav = provider.isFavorite(wallpaperId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: wallpaper.url,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image, size: 64),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () => provider.toggleFavorite(wallpaper),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and source
                  Text(
                    wallpaper.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.image, wallpaper.source),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                          context, Icons.aspect_ratio, wallpaper.resolution),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        context,
                        Icons.circle,
                        wallpaper.purity.toUpperCase(),
                        color: wallpaper.purity == 'sfw'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tags
                  if (wallpaper.tags.isNotEmpty) ...[
                    Text('Tags',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: wallpaper.tags.map((tag) {
                        return Chip(
                          label: Text(tag, style: const TextStyle(fontSize: 12)),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Author
                  if (wallpaper.author != null) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(wallpaper.author!),
                      subtitle: const Text('Author'),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Size info
                  _buildInfoRow(context, 'File Size',
                      '${(wallpaper.fileSize / 1024 / 1024).toStringAsFixed(1)} MB'),
                  _buildInfoRow(
                      context, 'Dimensions', wallpaper.resolution),
                  if (wallpaper.pageUrl != null)
                    _buildInfoRow(context, 'Source', wallpaper.pageUrl!),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _downloadWallpaper(context, wallpaper),
                  icon: const Icon(Icons.download),
                  label: Text(loc.tr('download')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _setWallpaper(context, wallpaper),
                  icon: const Icon(Icons.wallpaper),
                  label: Text(loc.tr('setWallpaper')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label,
      {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.outline)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _downloadWallpaper(BuildContext context, Wallpaper wallpaper) {
    final downloadService = context.read<DownloadService>();
    final fileName =
        '${wallpaper.source}_${wallpaper.id}.${wallpaper.url.split('.').last}';
    downloadService.downloadFile(
      id: wallpaper.id,
      url: wallpaper.url,
      fileName: fileName,
      source: wallpaper.source,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download started')),
    );
  }

  void _setWallpaper(BuildContext context, Wallpaper wallpaper) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setting wallpaper...')),
    );
    // In a real app, download first then set
    // await WallpaperService.setWallpaper(filePath);
  }
}
