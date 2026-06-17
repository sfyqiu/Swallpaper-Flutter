import 'package:flutter/foundation.dart';
import 'api_key_service.dart';
import 'base_source.dart';
import 'wallhaven_source.dart';
import 'unsplash_source.dart';

class SourceManager {
  static final SourceManager _instance = SourceManager._();
  factory SourceManager() => _instance;
  SourceManager._();

  final Map<String, WallpaperSource> _sources = {};

  WallpaperSource? getSource(String name) => _sources[name];

  List<String> get sourceNames => _sources.keys.toList();

  List<WallpaperSource> get sources => _sources.values.toList();

  void registerSource(WallpaperSource source) {
    _sources[source.name] = source;
  }

  Future<void> initialize() async {
    final apiKeys = ApiKeyService();

    // Wallhaven
    final wallhaven = WallhavenSource();
    final whKey = apiKeys.getKey('wallhaven');
    if (whKey != null) wallhaven.setApiKey(whKey);
    registerSource(wallhaven);

    // Unsplash (requires API key)
    final unsplash = UnsplashSource();
    final usKey = apiKeys.getKey('unsplash');
    if (usKey != null) unsplash.setApiKey(usKey);
    registerSource(unsplash);

    debugPrint('SourceManager initialized with ${_sources.length} sources');
  }

  void setApiKey(String sourceName, String key) {
    final source = _sources[sourceName];
    if (source is WallhavenSource) {
      source.setApiKey(key);
    } else if (source is UnsplashSource) {
      source.setApiKey(key);
    }
    // Persist the key
    ApiKeyService().setKey(sourceName, key);
  }
}
