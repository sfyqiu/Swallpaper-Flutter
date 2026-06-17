import 'package:flutter/foundation.dart';
import '../models/wallpaper.dart';
import '../models/media_item.dart';
import '../services/source_manager.dart';

class WallpaperProvider extends ChangeNotifier {
  final SourceManager _sourceManager = SourceManager();

  List<Wallpaper> _wallpapers = [];
  List<Wallpaper> _favorites = [];
  Map<String, List<Wallpaper>> _sourceWallpapers = {};
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  String _currentSource = 'Wallhaven';
  String? _currentQuery;
  String _currentCategory = '111';
  String _currentPurity = '100';
  String _currentSorting = 'date_added';

  // Getters
  List<Wallpaper> get wallpapers => _wallpapers;
  List<Wallpaper> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  String get currentSource => _currentSource;
  List<String> get sourceNames => _sourceManager.sourceNames;

  Future<void> initialize() async {
    await _sourceManager.initialize();
    await fetchWallpapers();
  }

  Future<void> fetchWallpapers({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && !_hasMore) return;

    _isLoading = true;
    _error = null;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    notifyListeners();

    try {
      final source = _sourceManager.getSource(_currentSource);
      if (source == null) {
        throw Exception('Source not found: $_currentSource');
      }

      final results = await source.fetchWallpapers(
        page: _currentPage,
        query: _currentQuery,
        category: _currentCategory,
        purity: _currentPurity,
        sorting: _currentSorting,
      );

      if (refresh) {
        _wallpapers = results;
      } else {
        _wallpapers.addAll(results);
      }

      _hasMore = results.length >= 30;
      _currentPage++;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSource(String source) {
    if (_currentSource != source) {
      _currentSource = source;
      _wallpapers = [];
      _currentPage = 1;
      _hasMore = true;
      fetchWallpapers();
    }
  }

  void setQuery(String? query) {
    _currentQuery = query;
    fetchWallpapers(refresh: true);
  }

  void toggleFavorite(Wallpaper wallpaper) {
    final exists = _favorites.any((f) => f.id == wallpaper.id);
    if (exists) {
      _favorites.removeWhere((f) => f.id == wallpaper.id);
    } else {
      _favorites.add(wallpaper);
    }
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((f) => f.id == id);

  void setApiKey(String source, String key) {
    _sourceManager.setApiKey(source, key);
  }
}
