import 'package:flutter_test/flutter_test.dart';
import 'package:swallpaper/models/wallpaper.dart';

void main() {
  group('Wallpaper Model', () {
    test('should create wallpaper with required fields', () {
      final wallpaper = Wallpaper(
        id: 'test-1',
        source: 'wallhaven',
        title: 'Test Wallpaper',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );

      expect(wallpaper.id, 'test-1');
      expect(wallpaper.source, 'wallhaven');
      expect(wallpaper.title, 'Test Wallpaper');
      expect(wallpaper.url, 'https://example.com/image.jpg');
      expect(wallpaper.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(wallpaper.isVideo, false);
    });

    test('should detect video wallpapers', () {
      final wallpaper = Wallpaper(
        id: 'test-2',
        source: 'coverr',
        title: 'Test Video',
        url: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );

      expect(wallpaper.isVideo, true);
    });

    test('should calculate aspect ratio', () {
      final wallpaper = Wallpaper(
        id: 'test-3',
        source: 'wallhaven',
        title: 'Test',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        width: 1920,
        height: 1080,
      );

      expect(wallpaper.aspectRatio, 1920 / 1080);
      expect(wallpaper.isLandscape, true);
      expect(wallpaper.isPortrait, false);
    });

    test('should serialize to and from JSON', () {
      final wallpaper = Wallpaper(
        id: 'test-4',
        source: 'pexels',
        title: 'JSON Test',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        tags: ['nature', 'mountain'],
        width: 3840,
        height: 2160,
      );

      final json = wallpaper.toJson();
      final restored = Wallpaper.fromJson(json);

      expect(restored.id, wallpaper.id);
      expect(restored.source, wallpaper.source);
      expect(restored.title, wallpaper.title);
      expect(restored.width, wallpaper.width);
      expect(restored.height, wallpaper.height);
      expect(restored.tags.length, 2);
    });
  });
}
