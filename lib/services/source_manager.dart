import '../models/models.dart';
import 'sources/wallpaper_sources.dart';
import 'sources/media_sources.dart';

/// Central manager for all wallpaper and media sources
class SourceManager {
  static final SourceManager _instance = SourceManager._();
  factory SourceManager() => _instance;
  SourceManager._();

  // Wallpaper sources
  late final WallhavenSource wallhaven;
  late final UnsplashSource unsplash;
  late final PexelsSource pexels;
  late final NasaApodSource nasaApod;
  late final FourKSource fourK;
  late final WallsflowSource wallsflow;

  // Media sources
  late final MotionBGSource motionBg;
  late final CoverrSource coverr;
  late final PexelsVideoSource pexelsVideo;

  final List<String> _wallpaperSourceNames = [];
  final List<String> _mediaSourceNames = [];

  List<String> get wallpaperSourceNames => _wallpaperSourceNames;
  List<String> get mediaSourceNames => _mediaSourceNames;

  void initialize() {
    wallhaven = WallhavenSource();
    unsplash = UnsplashSource();
    pexels = PexelsSource();
    nasaApod = NasaApodSource();
    fourK = FourKSource();
    wallsflow = WallsflowSource();

    _wallpaperSourceNames.addAll([
      wallhaven.name, unsplash.name, pexels.name,
      nasaApod.name, fourK.name, wallsflow.name,
    ]);

    motionBg = MotionBGSource();
    coverr = CoverrSource();
    pexelsVideo = PexelsVideoSource();

    _mediaSourceNames.addAll([
      motionBg.name, coverr.name, pexelsVideo.name,
    ]);
  }

  void setApiKey(String source, String key) {
    if (source == wallhaven.name) wallhaven.setApiKey(key);
    if (source == unsplash.name) unsplash.setApiKey(key);
    if (source == pexels.name || source == pexelsVideo.name) {
      pexels.setApiKey(key);
      pexelsVideo.setApiKey(key);
    }
  }

  // Dynamic fetch based on source type
  Future<List<Wallpaper>> fetchWallpapers(String sourceName, {int page = 1, String? query, String? categories, String? purity, String? sorting}) async {
    switch (sourceName) {
      case 'Wallhaven':
        return wallhaven.fetchWallpapers(page: page, query: query, categories: categories, purity: purity, sorting: sorting);
      case 'Unsplash':
        return unsplash.fetchWallpapers(page: page, query: query, sorting: sorting);
      case 'Pexels':
        return pexels.fetchWallpapers(page: page, query: query);
      case 'NASA APOD':
        return nasaApod.fetchWallpapers(page: page);
      case '4K Wallpapers':
        return fourK.fetchWallpapers(page: page, query: query);
      case 'Wallsflow':
        return wallsflow.fetchWallpapers(page: page);
      default:
        return [];
    }
  }

  Future<List<MediaItem>> fetchMedia(String sourceName, {int page = 1, String? query}) async {
    switch (sourceName) {
      case 'MotionBG':
        return motionBg.fetchMedia(page: page, query: query);
      case 'Coverr':
        return coverr.fetchMedia(page: page, query: query);
      case 'Pexels Videos':
        return pexelsVideo.fetchMedia(page: page, query: query);
      default:
        return [];
    }
  }

  Future<Wallpaper> fetchWallpaperDetail(String sourceName, String id) async {
    switch (sourceName) {
      case 'Wallhaven': return wallhaven.fetchDetail(id);
      case 'Unsplash': return unsplash.fetchDetail(id);
      case 'Pexels': return pexels.fetchDetail(id);
      default: throw Exception('Detail not available for $sourceName');
    }
  }
}
