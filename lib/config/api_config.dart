class ApiConfig {
  // Wallhaven
  static const String wallhavenBaseUrl = 'https://wallhaven.cc/api/v1';
  static const String wallhavenKey = ''; // Optional, set in settings

  // Unsplash
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static const String unsplashKey = ''; // Required, set in settings

  // Pexels
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1';
  static const String pexelsVideoBaseUrl = 'https://api.pexels.com/videos';
  static const String pexelsKey = ''; // Required, set in settings

  // NASA
  static const String nasaBaseUrl = 'https://api.nasa.gov';
  static const String nasaImagesBaseUrl = 'https://images-api.nasa.gov';
  static const String nasaKey = 'DEMO_KEY'; // Optional, upgrade in settings

  // 4K Wallpapers
  static const String fourKBaseUrl = 'https://4kwallpapers.com';

  // Coverr
  static const String coverrBaseUrl = 'https://coverr.co/api';

  // MotionBG
  static const String motionBgBaseUrl = 'https://motionbgs.com/api';

  // App
  static const String appName = 'Swallpaper';
  static const String appVersion = '1.0.0';
  static const String repoUrl = 'https://github.com/sfyqiu/Swallpaper-Flutter';

  // Pagination
  static const int pageSize = 30;
  static const int gridCrossAxisCount = 2;

  // Cache
  static const int cacheMaxAgeDays = 7;
  static const String cacheDir = 'swallpaper_cache';
  static const String thumbnailsDir = 'thumbnails';
}
