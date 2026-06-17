import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/wallpaper.dart';
import 'base_source.dart';

class UnsplashSource extends WallpaperSource {
  @override
  String get name => 'Unsplash';

  @override
  String get baseUrl => ApiConfig.unsplashBaseUrl;

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
    final uri = Uri.parse('$baseUrl/photos').replace(queryParameters: {
      'page': page.toString(),
      'per_page': '30',
      'order_by': sorting ?? 'latest',
      if (query != null && query.isNotEmpty) 'query': query,
    });

    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((item) {
        final photo = item as Map<String, dynamic>;
        final urls = photo['urls'] as Map<String, dynamic>;
        final user = photo['user'] as Map<String, dynamic>?;
        return Wallpaper(
          id: photo['id'] as String,
          source: 'unsplash',
          title: photo['alt_description'] as String? ?? 'Untitled',
          url: urls['full'] as String,
          thumbnailUrl: urls['small'] as String,
          originalUrl: urls['raw'] as String,
          tags: (photo['tags'] as List<dynamic>?)
                  ?.map((t) => (t as Map<String, dynamic>)['title'] as String)
                  .toList() ??
              [],
          category: 'general',
          purity: 'sfw',
          width: photo['width'] as int? ?? 0,
          height: photo['height'] as int? ?? 0,
          author: user?['name'] as String?,
          authorUrl: user?['links']?['html'] as String?,
          pageUrl: photo['links']?['html'] as String?,
        );
      }).toList();
    } else {
      throw Exception('Unsplash API error: ${response.statusCode}');
    }
  }

  @override
  Future<Wallpaper> fetchWallpaperDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photos/$id'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final photo = json.decode(response.body) as Map<String, dynamic>;
      final urls = photo['urls'] as Map<String, dynamic>;
      final user = photo['user'] as Map<String, dynamic>?;
      return Wallpaper(
        id: photo['id'] as String,
        source: 'unsplash',
        title: photo['alt_description'] as String? ?? 'Untitled',
        url: urls['full'] as String,
        thumbnailUrl: urls['small'] as String,
        originalUrl: urls['raw'] as String,
        width: photo['width'] as int? ?? 0,
        height: photo['height'] as int? ?? 0,
        author: user?['name'] as String?,
        authorUrl: user?['links']?['html'] as String?,
        pageUrl: photo['links']?['html'] as String?,
      );
    } else {
      throw Exception('Unsplash detail error: ${response.statusCode}');
    }
  }

  Map<String, String> get _headers => {
        'Authorization': 'Client-ID $_apiKey',
        'Accept': 'application/json',
      };
}
