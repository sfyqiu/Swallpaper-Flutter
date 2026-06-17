import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'source_manager.dart';

/// Main state provider for the app
class AppState extends ChangeNotifier {
  final SourceManager _sourceManager = SourceManager();

  // Wallpaper explore state
  List<Wallpaper> _wallpapers = [];
  bool _wallpapersLoading = false;
  String? _wallpapersError;
  int _wallpaperPage = 1;
  bool _wallpaperHasMore = true;
  String _currentWallpaperSource = 'Wallhaven';
  String? _searchQuery;
  String _categories = '111';
  String _purity = '100';
  String _sorting = 'date_added';

  // Media explore state
  List<MediaItem> _mediaItems = [];
  bool _mediaLoading = false;
  String? _mediaError;
  int _mediaPage = 1;
  bool _mediaHasMore = true;
  String _currentMediaSource = 'MotionBG';

  // Home state
  List<Wallpaper> _homeWallpapers = [];
  List<MediaItem> _homeMedia = [];
  bool _homeLoading = false;

  // Favorites
  List<FavoriteItem> _favorites = [];

  // Getters
  List<Wallpaper> get wallpapers => _wallpapers;
  bool get wallpapersLoading => _wallpapersLoading;
  String? get wallpapersError => _wallpapersError;
  bool get wallpaperHasMore => _wallpaperHasMore;
  String get currentWallpaperSource => _currentWallpaperSource;
  List<MediaItem> get mediaItems => _mediaItems;
  bool get mediaLoading => _mediaLoading;
  String? get mediaError => _mediaError;
  bool get mediaHasMore => _mediaHasMore;
  String get currentMediaSource => _currentMediaSource;
  List<Wallpaper> get homeWallpapers => _homeWallpapers;
  List<MediaItem> get homeMedia => _homeMedia;
  bool get homeLoading => _homeLoading;
  List<FavoriteItem> get favorites => _favorites;
  List<String> get wallpaperSources => _sourceManager.wallpaperSourceNames;
  List<String> get mediaSources => _sourceManager.mediaSourceNames;

  void init() => _sourceManager.initialize();

  // === Wallpaper Explore ===
  Future<void> fetchWallpapers({bool refresh = false}) async {
    if (_wallpapersLoading) return;
    if (!refresh && !_wallpaperHasMore) return;

    _wallpapersLoading = true;
    _wallpapersError = null;
    if (refresh) { _wallpaperPage = 1; _wallpaperHasMore = true; }
    notifyListeners();

    try {
      final results = await _sourceManager.fetchWallpapers(
        _currentWallpaperSource,
        page: _wallpaperPage, query: _searchQuery,
        categories: _categories, purity: _purity, sorting: _sorting,
      );
      if (refresh) {
        _wallpapers = results;
      } else {
        _wallpapers.addAll(results);
      }
      _wallpaperHasMore = results.isNotEmpty;
      _wallpaperPage++;
    } catch (e) {
      _wallpapersError = e.toString();
    }
    _wallpapersLoading = false;
    notifyListeners();
  }

  void setWallpaperSource(String source) {
    if (_currentWallpaperSource != source) {
      _currentWallpaperSource = source;
      _wallpapers = [];
      _wallpaperPage = 1;
      _wallpaperHasMore = true;
      fetchWallpapers();
    }
  }

  void setSearchQuery(String? query) {
    _searchQuery = query?.isEmpty == true ? null : query;
    fetchWallpapers(refresh: true);
  }

  void setFilters({String? categories, String? purity, String? sorting}) {
    _categories = categories ?? _categories;
    _purity = purity ?? _purity;
    _sorting = sorting ?? _sorting;
    fetchWallpapers(refresh: true);
  }

  // === Media Explore ===
  Future<void> fetchMedia({bool refresh = false}) async {
    if (_mediaLoading) return;
    if (!refresh && !_mediaHasMore) return;

    _mediaLoading = true;
    _mediaError = null;
    if (refresh) { _mediaPage = 1; _mediaHasMore = true; }
    notifyListeners();

    try {
      final results = await _sourceManager.fetchMedia(_currentMediaSource, page: _mediaPage);
      if (refresh) {
        _mediaItems = results;
      } else {
        _mediaItems.addAll(results);
      }
      _mediaHasMore = results.isNotEmpty;
      _mediaPage++;
    } catch (e) {
      _mediaError = e.toString();
    }
    _mediaLoading = false;
    notifyListeners();
  }

  void setMediaSource(String source) {
    if (_currentMediaSource != source) {
      _currentMediaSource = source;
      _mediaItems = [];
      _mediaPage = 1;
      _mediaHasMore = true;
      fetchMedia();
    }
  }

  // === Home ===
  Future<void> fetchHomeContent() async {
    _homeLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _sourceManager.fetchWallpapers('Wallhaven', page: 1, sorting: 'toplist'),
        _sourceManager.fetchWallpapers('Wallhaven', page: 1, sorting: 'date_added'),
        _sourceManager.fetchMedia('MotionBG'),
      ], eagerError: false);

      _homeWallpapers = (results[1] as List<Wallpaper>).take(20).toList();
      _homeMedia = (results[2] as List<MediaItem>).take(10).toList();
    } catch (_) {}
    _homeLoading = false;
    notifyListeners();
  }

  // === Favorites ===
  void toggleFavorite(dynamic item, String type) {
    final id = item is Wallpaper ? item.id : (item as MediaItem).id;
    final existing = _favorites.indexWhere((f) => f.id == id);
    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      _favorites.add(FavoriteItem(id: id, item: item, type: type));
    }
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((f) => f.id == id);

  void setApiKey(String source, String key) {
    _sourceManager.setApiKey(source, key);
  }
}
