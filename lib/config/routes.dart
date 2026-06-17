import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/library_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/wallpaper_detail_screen.dart';
import '../screens/video_player_screen.dart';

class Routes {
  static const String home = '/';
  static const String explore = '/explore';
  static const String library = '/library';
  static const String settings = '/settings';
  static const String wallpaperDetail = '/wallpaper-detail';
  static const String videoPlayer = '/video-player';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case explore:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ExploreScreen(sourceType: args?['source'] as String?),
        );
      case library:
        return MaterialPageRoute(builder: (_) => const LibraryScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case wallpaperDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => WallpaperDetailScreen(
            wallpaperId: args['id'] as String,
            source: args['source'] as String,
          ),
        );
      case videoPlayer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(
            videoUrl: args['url'] as String,
            title: args['title'] as String?,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
