import 'package:flutter_test/flutter_test.dart';
import 'package:swallpaper/models/models.dart';

void main() {
  group('Wallpaper Model', () {
    test('creates wallpaper with required fields', () {
      final wp = Wallpaper(
        id: 'test-1', source: 'wallhaven',
        url: 'https://example.com/img.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );
      expect(wp.id, 'test-1');
      expect(wp.source, 'wallhaven');
      expect(wp.isVideo, false);
    });

    test('detects video wallpapers', () {
      final wp = Wallpaper(
        id: 'test-2', source: 'coverr',
        url: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );
      expect(wp.isVideo, true);
    });

    test('serializes to and from JSON', () {
      final wp = Wallpaper(
        id: 'test-3', source: 'pexels', title: 'Test',
        url: 'https://example.com/img.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        tags: ['nature', 'mountain'],
        width: 3840, height: 2160,
      );
      final json = wp.toJson();
      final restored = Wallpaper.fromJson(json);
      expect(restored.id, wp.id);
      expect(restored.source, wp.source);
      expect(restored.width, 3840);
      expect(restored.height, 2160);
    });

    test('copyWith works', () {
      final wp = Wallpaper(
        id: 'test-4', source: 'wallhaven',
        url: 'https://example.com/img.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        title: 'Original',
      );
      final copy = wp.copyWith(title: 'Changed');
      expect(copy.title, 'Changed');
      expect(copy.id, wp.id);
    });
  });

  group('MediaItem Model', () {
    test('creates media item', () {
      final media = MediaItem(
        id: 'media-1', source: 'motionbg', title: 'Test Video',
        url: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        type: 'video',
      );
      expect(media.isVideo, true);
      expect(media.isImage, false);
    });
  });

  group('DownloadTask', () {
    test('progress calculation', () {
      final task = DownloadTask(
        id: 'dl-1', url: 'https://example.com/file.mp4',
        fileName: 'file.mp4', filePath: '/tmp/file.mp4',
        source: 'test', totalBytes: 100, receivedBytes: 50,
        status: DownloadStatus.downloading,
      );
      expect(task.progress, 0.5);
      expect(task.isActive, true);
    });
  });
}
