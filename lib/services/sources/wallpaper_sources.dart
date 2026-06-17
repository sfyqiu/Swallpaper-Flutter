import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

/// Abstract base for wallpaper sources
abstract class WallpaperSource {
  String get name;
  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1,
    String? query,
    String? categories,
    String? purity,
    String? sorting,
    String? resolution,
  });
  Future<Wallpaper> fetchDetail(String id);
}

/// Wallhaven API source
class WallhavenSource extends WallpaperSource {
  @override
  String get name => 'Wallhaven';
  static const _baseUrl = 'https://wallhaven.cc/api/v1';

  String _apiKey = '';
  void setApiKey(String key) => _apiKey = key;

  @override
  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1,
    String? query,
    String? categories = '111',
    String? purity = '100',
    String? sorting = 'date_added',
    String? resolution = '1920x1080',
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'categories': categories,
      'purity': purity,
      'sorting': sorting,
      'order': 'desc',
      'atleast': resolution,
    };
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (_apiKey.isNotEmpty) params['apikey'] = _apiKey;

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Wallhaven: ${res.statusCode}');

    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data['data'] as List).map((item) {
      final w = item as Map<String, dynamic>;
      return Wallpaper(
        id: w['id'] as String,
        source: 'wallhaven',
        title: (w['tags'] as List?)?.take(3).map((t) => (t as Map)['name']).join(', ') ?? '',
        url: w['path'] as String,
        thumbnailUrl: (w['thumbs'] as Map)['small'] as String,
        tags: (w['tags'] as List?)?.map((t) => (t as Map)['name'] as String).toList() ?? [],
        category: w['category'] as String? ?? 'general',
        purity: w['purity'] as String? ?? 'sfw',
        width: w['dimension_x'] as int? ?? 0,
        height: w['dimension_y'] as int? ?? 0,
        fileSize: w['file_size'] as int? ?? 0,
        pageUrl: w['url'] as String?,
        resolution: w['resolution'] as String?,
      );
    }).toList();
  }

  @override
  Future<Wallpaper> fetchDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/wallpaper/$id');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Wallhaven detail: ${res.statusCode}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final w = data['data'] as Map<String, dynamic>;
    return Wallpaper(
      id: w['id'] as String, source: 'wallhaven',
      title: (w['tags'] as List?)?.take(3).map((t) => (t as Map)['name']).join(', ') ?? '',
      url: w['path'] as String, thumbnailUrl: (w['thumbs'] as Map)['small'] as String,
      tags: (w['tags'] as List?)?.map((t) => (t as Map)['name'] as String).toList() ?? [],
      category: w['category'] as String? ?? 'general', purity: w['purity'] as String? ?? 'sfw',
      width: w['dimension_x'] as int? ?? 0, height: w['dimension_y'] as int? ?? 0,
      fileSize: w['file_size'] as int? ?? 0, pageUrl: w['url'] as String?,
      resolution: w['resolution'] as String?,
    );
  }

  Map<String, String> get _headers => {'Accept': 'application/json'};
}

/// Unsplash source
class UnsplashSource extends WallpaperSource {
  @override
  String get name => 'Unsplash';
  static const _baseUrl = 'https://api.unsplash.com';

  String _apiKey = '';
  void setApiKey(String key) => _apiKey = key;

  @override
  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1, String? query, String? categories, String? purity,
    String? sorting, String? resolution,
  }) async {
    final uri = Uri.parse('$_baseUrl/photos').replace(queryParameters: {
      'page': page.toString(), 'per_page': '30',
      'order_by': sorting ?? 'latest',
      if (query != null && query.isNotEmpty) 'query': query,
    });
    final res = await http.get(uri, headers: _authHeaders);
    if (res.statusCode != 200) throw Exception('Unsplash: ${res.statusCode}');

    final data = json.decode(res.body) as List;
    return data.map((item) {
      final p = item as Map<String, dynamic>;
      final urls = p['urls'] as Map<String, dynamic>;
      final user = p['user'] as Map<String, dynamic>?;
      return Wallpaper(
        id: 'unsplash-${p['id']}', source: 'unsplash',
        title: p['alt_description'] as String? ?? '',
        url: urls['full'] as String, thumbnailUrl: urls['small'] as String,
        originalUrl: urls['raw'] as String,
        width: p['width'] as int? ?? 0, height: p['height'] as int? ?? 0,
        author: user?['name'] as String?,
        authorUrl: user?['links']?['html'] as String?,
        pageUrl: p['links']?['html'] as String?,
      );
    }).toList();
  }

  @override
  Future<Wallpaper> fetchDetail(String id) async {
    final res = await http.get(Uri.parse('$_baseUrl/photos/$id'), headers: _authHeaders);
    if (res.statusCode != 200) throw Exception('Unsplash detail: ${res.statusCode}');
    final p = json.decode(res.body) as Map<String, dynamic>;
    final urls = p['urls'] as Map<String, dynamic>;
    final user = p['user'] as Map<String, dynamic>?;
    return Wallpaper(
      id: 'unsplash-${p['id']}', source: 'unsplash',
      title: p['alt_description'] as String? ?? '',
      url: urls['full'] as String, thumbnailUrl: urls['small'] as String,
      originalUrl: urls['raw'] as String,
      width: p['width'] as int? ?? 0, height: p['height'] as int? ?? 0,
      author: user?['name'] as String?, authorUrl: user?['links']?['html'] as String?,
      pageUrl: p['links']?['html'] as String?,
    );
  }

  Map<String, String> get _authHeaders => {
    'Authorization': 'Client-ID $_apiKey',
    'Accept': 'application/json',
  };
}

/// Pexels source
class PexelsSource extends WallpaperSource {
  @override
  String get name => 'Pexels';
  static const _baseUrl = 'https://api.pexels.com/v1';

  String _apiKey = '';
  void setApiKey(String key) => _apiKey = key;

  @override
  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1, String? query, String? categories, String? purity,
    String? sorting, String? resolution,
  }) async {
    final endpoint = (query != null && query.isNotEmpty) ? 'search' : 'curated';
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: {
      'page': page.toString(), 'per_page': '30',
      if (query != null && query.isNotEmpty) 'query': query,
    });
    final res = await http.get(uri, headers: _authHeaders);
    if (res.statusCode != 200) throw Exception('Pexels: ${res.statusCode}');

    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data['photos'] as List).map((item) {
      final p = item as Map<String, dynamic>;
      final src = p['src'] as Map<String, dynamic>;
      final photographer = p['photographer'] as String?;
      return Wallpaper(
        id: 'pexels-${p['id']}', source: 'pexels',
        title: p['alt'] as String? ?? '',
        url: src['original'] as String, thumbnailUrl: src['medium'] as String,
        originalUrl: src['original'] as String,
        width: p['width'] as int? ?? 0, height: p['height'] as int? ?? 0,
        author: photographer, pageUrl: p['url'] as String?,
      );
    }).toList();
  }

  @override
  Future<Wallpaper> fetchDetail(String id) async {
    final idNum = id.replaceFirst('pexels-', '');
    final res = await http.get(Uri.parse('$_baseUrl/photos/$idNum'), headers: _authHeaders);
    if (res.statusCode != 200) throw Exception('Pexels detail: ${res.statusCode}');
    final p = json.decode(res.body) as Map<String, dynamic>;
    final src = p['src'] as Map<String, dynamic>;
    return Wallpaper(
      id: 'pexels-${p['id']}', source: 'pexels',
      title: p['alt'] as String? ?? '',
      url: src['original'] as String, thumbnailUrl: src['medium'] as String,
      width: p['width'] as int? ?? 0, height: p['height'] as int? ?? 0,
      author: p['photographer'] as String?, pageUrl: p['url'] as String?,
    );
  }

  Map<String, String> get _authHeaders => {
    'Authorization': _apiKey,
    'Accept': 'application/json',
  };
}
