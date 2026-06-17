import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/wallpaper.dart';
import 'base_source.dart';

class WallhavenSource extends WallpaperSource {
  @override
  String get name => 'Wallhaven';

  @override
  String get baseUrl => ApiConfig.wallhavenBaseUrl;

  String _apiKey = '';

  void setApiKey(String key) => _apiKey = key;

  @override
  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1,
    String? query,
    String? category,
    String? purity,
    String? sorting,
    String? resolution,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'categories': category ?? '111',
      'purity': purity ?? '100',
      'sorting': sorting ?? 'date_added',
      'order': 'desc',
      'atleast': resolution ?? '1920x1080',
      'topRange': '1M',
    };

    if (query != null && query.isNotEmpty) {
      params['q'] = query;
    }

    if (_apiKey.isNotEmpty) {
      params['apikey'] = _apiKey;
    }

    final uri = Uri.parse('$baseUrl/search').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final wallpapers = (data['data'] as List<dynamic>).map((item) {
        final wall = item as Map<String, dynamic>;
        return Wallpaper(
          id: wall['id'] as String,
          source: 'wallhaven',
          title: (wall['tags'] as List<dynamic>?)
                  ?.take(3)
                  .map((t) => (t as Map<String, dynamic>)['name'] as String)
                  .join(', ') ??
              'Untitled',
          url: wall['path'] as String,
          thumbnailUrl: (wall['thumbs'] as Map<String, dynamic>)['small'] as String,
          originalUrl: wall['path'] as String,
          tags: (wall['tags'] as List<dynamic>?)
                  ?.map((t) => (t as Map<String, dynamic>)['name'] as String)
                  .toList() ??
              [],
          category: wall['category'] as String? ?? 'general',
          purity: wall['purity'] as String? ?? 'sfw',
          width: wall['dimension_x'] as int? ?? 0,
          height: wall['dimension_y'] as int? ?? 0,
          fileSize: wall['file_size'] as int? ?? 0,
          pageUrl: wall['url'] as String?,
        );
      }).toList();

      return wallpapers;
    } else {
      throw Exception('Wallhaven API error: ${response.statusCode}');
    }
  }

  @override
  Future<Wallpaper> fetchWallpaperDetail(String id) async {
    final uri = Uri.parse('$baseUrl/wallpaper/$id');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final wall = data['data'] as Map<String, dynamic>;
      return Wallpaper(
        id: wall['id'] as String,
        source: 'wallhaven',
        title: (wall['tags'] as List<dynamic>?)
                ?.take(3)
                .map((t) => (t as Map<String, dynamic>)['name'] as String)
                .join(', ') ??
            'Untitled',
        url: wall['path'] as String,
        thumbnailUrl: (wall['thumbs'] as Map<String, dynamic>)['small'] as String,
        originalUrl: wall['path'] as String,
        tags: (wall['tags'] as List<dynamic>?)
                ?.map((t) => (t as Map<String, dynamic>)['name'] as String)
                .toList() ??
            [],
        category: wall['category'] as String? ?? 'general',
        purity: wall['purity'] as String? ?? 'sfw',
        width: wall['dimension_x'] as int? ?? 0,
        height: wall['dimension_y'] as int? ?? 0,
        fileSize: wall['file_size'] as int? ?? 0,
        author: wall['uploader'] as Map<String, dynamic>? ?['username'] as String?,
        pageUrl: wall['url'] as String?,
      );
    } else {
      throw Exception('Wallhaven detail error: ${response.statusCode}');
    }
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
