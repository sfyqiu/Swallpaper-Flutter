import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

/// MotionBG video source
class MotionBGSource {
  String get name => 'MotionBG';
  static const _baseUrl = 'https://motionbgs.com';

  Future<List<MediaItem>> fetchMedia({int page = 1, String? query, String? category}) async {
    final uri = Uri.parse('$_baseUrl/api/videos${query != null ? '/search' : ''}')
        .replace(queryParameters: {
      'page': page.toString(),
      'limit': '30',
      if (query != null && query.isNotEmpty) 'q': query,
      if (category != null) 'category': category,
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('MotionBG: ${res.statusCode}');

    final data = json.decode(res.body);
    if (data is Map && data.containsKey('error')) {
      // Fallback: parse HTML-based API
      return _fallbackParse(page, query);
    }

    final items = (data is List ? data : data['data'] ?? data['items'] ?? []) as List;
    return items.map((item) {
      final m = item as Map<String, dynamic>;
      final id = m['_id']?.toString() ?? m['id']?.toString() ?? '';
      return MediaItem(
        id: 'mbg-$id',
        source: 'motionbg',
        title: m['title'] as String? ?? m['name'] as String? ?? '',
        url: m['videoUrl'] as String? ?? m['downloadUrl'] as String? ?? '',
        thumbnailUrl: m['thumbnail'] as String? ?? m['thumb'] as String? ?? '',
        previewVideoUrl: m['previewUrl'] as String? ?? m['gif'] as String?,
        type: 'video',
        duration: m['duration'] as int?,
        width: m['width'] as int? ?? 1920,
        height: m['height'] as int? ?? 1080,
        author: m['author'] as String? ?? m['uploader'] as String?,
      );
    }).toList();
  }

  Future<List<MediaItem>> _fallbackParse(int page, String? query) async {
    // HTML scrape fallback - simplified
    final url = '$_baseUrl${query != null ? '/search?q=${Uri.encodeComponent(query)}' : ''}&page=$page';
    final res = await http.get(Uri.parse(url));
    // Simplified; real impl would parse HTML
    return [];
  }
}

/// Coverr video source
class CoverrSource {
  String get name => 'Coverr';
  static const _baseUrl = 'https://coverr.co/api/videos';

  Future<List<MediaItem>> fetchMedia({int page = 1, String? query}) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'page': page.toString(),
      'per_page': '30',
      'sort': 'newest',
      if (query != null && query.isNotEmpty) 'q': query,
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Coverr: ${res.statusCode}');

    final data = json.decode(res.body) as Map<String, dynamic>;
    final items = data['data'] as List? ?? data['items'] as List? ?? [];
    return items.map((item) {
      final m = item as Map<String, dynamic>;
      final id = m['id']?.toString() ?? '';
      final videos = m['videos'] as List? ?? [];
      final mp4Url = videos.isNotEmpty
          ? (videos.firstWhere((v) => (v as Map)['type'] == 'video/mp4',
                  orElse: () => videos.first) as Map)['url']
              ?.toString()
          : null;
      return MediaItem(
        id: 'coverr-$id', source: 'coverr',
        title: m['title'] as String? ?? '',
        url: mp4Url ?? '',
        thumbnailUrl: m['thumbnail'] as String? ?? m['poster'] as String? ?? '',
        type: 'video', duration: m['duration'] as int?,
        width: m['width'] as int? ?? 1920, height: m['height'] as int? ?? 1080,
      );
    }).toList();
  }
}

/// Pexels Videos source
class PexelsVideoSource {
  String get name => 'Pexels Videos';
  static const _baseUrl = 'https://api.pexels.com/videos';

  String _apiKey = '';
  void setApiKey(String key) => _apiKey = key;

  Future<List<MediaItem>> fetchMedia({int page = 1, String? query}) async {
    final endpoint = (query != null && query.isNotEmpty) ? 'search' : 'popular';
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: {
      'page': page.toString(), 'per_page': '30',
      if (query != null && query.isNotEmpty) 'query': query,
    });
    final res = await http.get(uri, headers: _authHeaders);
    if (res.statusCode != 200) throw Exception('Pexels Videos: ${res.statusCode}');

    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data['videos'] as List).map((item) {
      final v = item as Map<String, dynamic>;
      final videoFiles = v['video_files'] as List? ?? [];
      final videoPictures = v['video_pictures'] as List? ?? [];
      final hdVideo = videoFiles.whereType<Map<String, dynamic>>().toList();
      final bestVideo = hdVideo.isNotEmpty ? hdVideo.first : (videoFiles.isNotEmpty ? videoFiles.first as Map<String, dynamic> : {});
      return MediaItem(
        id: 'px-video-${v['id']}', source: 'pexels_videos',
        title: v['url']?.toString() ?? '',
        url: bestVideo['link'] as String? ?? '',
        thumbnailUrl: videoPictures.isNotEmpty ? (videoPictures.first as Map)['picture'] as String? ?? '' : '',
        type: 'video', duration: v['duration'] as int?,
        width: bestVideo['width'] as int? ?? 1920, height: bestVideo['height'] as int? ?? 1080,
        author: v['user']?['name'] as String?,
      );
    }).toList();
  }

  Map<String, String> get _authHeaders => {
    'Authorization': _apiKey,
    'Accept': 'application/json',
  };
}

/// NASA APOD source
class NasaApodSource {
  String get name => 'NASA APOD';

  Future<List<Wallpaper>> fetchWallpapers({int page = 1}) async {
    final count = 30;
    final uri = Uri.parse('https://api.nasa.gov/planetary/apod')
        .replace(queryParameters: {
      'count': count.toString(),
      'api_key': 'DEMO_KEY',
      'thumbs': 'true',
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('NASA APOD: ${res.statusCode}');

    final data = json.decode(res.body) as List;
    return data.map((item) {
      final a = item as Map<String, dynamic>;
      return Wallpaper(
        id: 'nasa-apod-${a['date']}', source: 'nasa_apod',
        title: a['title'] as String? ?? '',
        url: a['hdurl'] as String? ?? a['url'] as String? ?? '',
        thumbnailUrl: a['url'] as String? ?? '',
        originalUrl: a['hdurl'] as String?,
        tags: [a['explanation']?.toString().substring(0, 100) ?? ''],
        category: 'general', purity: 'sfw',
        author: a['copyright'] as String?,
        resolution: '1920x1080',
      );
    }).toList();
  }
}

/// 4K Wallpapers source
class FourKSource {
  String get name => '4K Wallpapers';

  Future<List<Wallpaper>> fetchWallpapers({int page = 1, String? query}) async {
    final base = 'https://4kwallpapers.com';
    final url = query != null && query.isNotEmpty
        ? '$base/search/$query?page=$page'
        : '$base/?page=$page';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('4K: ${res.statusCode}');
    // Note: Would need HTML parsing in production
    return [];
  }
}

/// Wallsflow source
class WallsflowSource {
  String get name => 'Wallsflow';

  Future<List<Wallpaper>> fetchWallpapers({int page = 1}) async {
    final url = 'https://wallsflow.com/api/wallpapers?page=$page&limit=30';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) throw Exception('Wallsflow: ${res.statusCode}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    return ((data['data'] ?? data['wallpapers'] ?? []) as List).map((item) {
      final w = item as Map<String, dynamic>;
      return Wallpaper(
        id: 'wf-${w['id'] ?? w['_id']}', source: 'wallsflow',
        title: w['title'] as String? ?? '',
        url: w['imageUrl'] as String? ?? w['url'] as String? ?? '',
        thumbnailUrl: w['thumbnail'] as String? ?? w['thumb'] as String? ?? '',
        tags: (w['tags'] as List?)?.cast<String>() ?? [],
        width: w['width'] as int? ?? 0, height: w['height'] as int? ?? 0,
        author: w['author'] as String?,
      );
    }).toList();
  }
}
