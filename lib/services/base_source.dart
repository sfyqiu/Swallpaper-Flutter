import '../models/wallpaper.dart';

abstract class WallpaperSource {
  String get name;
  String get baseUrl;

  Future<List<Wallpaper>> fetchWallpapers({
    int page = 1,
    String? query,
    String? category,
    String? purity,
    String? sorting,
    String? resolution,
  });

  Future<Wallpaper> fetchWallpaperDetail(String id);
}
