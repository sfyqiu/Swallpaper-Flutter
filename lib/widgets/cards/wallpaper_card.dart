import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Wallpaper grid card for explore grid
class WallpaperGridCard extends StatelessWidget {
  final dynamic wallpaper;
  final VoidCallback? onTap;

  const WallpaperGridCard({super.key, required this.wallpaper, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = wallpaper.url ?? wallpaper.thumbnailUrl ?? '';
    final title = wallpaper.title ?? '';

    return GestureDetector(
      onTap: onTap,
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
            // Image
            AspectRatio(
              aspectRatio: (wallpaper.aspectRatio ?? 16 / 9).toDouble().clamp(0.5, 3.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceBackground)),
                  // Source badge
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(wallpaper.source ?? '', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  // Purity badge
                  if (wallpaper.purity != null && wallpaper.purity != 'sfw')
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (wallpaper.purity == 'nsfw' ? AppColors.warningOrange : AppColors.accentOrange).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(wallpaper.purity.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isNotEmpty ? title : 'Untitled',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wallpaper.res ?? '${wallpaper.width}x${wallpaper.height}' ?? '',
                    style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal shelf card used in home screen
class ShelfCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final bool isVideo;
  final VoidCallback? onTap;

  const ShelfCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.isVideo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
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
