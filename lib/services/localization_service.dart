import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocalizationService {
  static const LocalizationsDelegate<LocalizationService> delegate =
      _LocalizationServiceDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('zh', 'CN'),
    Locale('ja', 'JP'),
  ];

  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'appName': 'Swallpaper',
      'explore': 'Explore',
      'library': 'Library',
      'settings': 'Settings',
      'home': 'Home',
      'search': 'Search wallpapers...',
      'favorites': 'Favorites',
      'downloads': 'Downloads',
      'noWallpapers': 'No wallpapers found',
      'loading': 'Loading...',
      'error': 'Something went wrong',
      'retry': 'Retry',
      'apply': 'Apply Wallpaper',
      'download': 'Download',
      'setWallpaper': 'Set as Wallpaper',
      'about': 'About',
      'theme': 'Theme',
      'language': 'Language',
      'source': 'Source',
      'apiKey': 'API Key',
      'enterApiKey': 'Enter API Key',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'wallhaven': 'Wallhaven',
      'unsplash': 'Unsplash',
      'pexels': 'Pexels',
      'pexelsVideos': 'Pexels Videos',
      'nasaApod': 'NASA APOD',
      'nasaImages': 'NASA Images',
      'fourKWallpapers': '4K Wallpapers',
      'coverr': 'Coverr',
      'motionBg': 'MotionBG',
      'filter': 'Filter',
      'category': 'Category',
      'resolution': 'Resolution',
      'sortBy': 'Sort by',
      'relevance': 'Relevance',
      'dateAdded': 'Date Added',
      'views': 'Views',
      'favorites_count': 'Favorites',
      'toplist': 'Top List',
      'random': 'Random',
      'sfw': 'Safe for Work',
      'sketchy': 'Sketchy',
      'nsfw': 'Not Safe for Work',
      'all': 'All',
      'general': 'General',
      'anime': 'Anime',
      'people': 'People',
      'cloudSync': 'Cloud Sync',
      'aboutDescription': 'A cross-platform wallpaper manager',
    },
    'zh': {
      'appName': 'Swallpaper',
      'explore': '发现',
      'library': '我的库',
      'settings': '设置',
      'home': '首页',
      'search': '搜索壁纸...',
      'favorites': '收藏',
      'downloads': '下载',
      'noWallpapers': '没有找到壁纸',
      'loading': '加载中...',
      'error': '出了点问题',
      'retry': '重试',
      'apply': '应用壁纸',
      'download': '下载',
      'setWallpaper': '设为壁纸',
      'about': '关于',
      'theme': '主题',
      'language': '语言',
      'source': '源',
      'apiKey': 'API 密钥',
      'enterApiKey': '输入 API 密钥',
      'save': '保存',
      'cancel': '取消',
      'confirm': '确认',
      'delete': '删除',
      'wallhaven': 'Wallhaven',
      'unsplash': 'Unsplash',
      'pexels': 'Pexels',
      'pexelsVideos': 'Pexels 视频',
      'nasaApod': 'NASA 每日天文',
      'nasaImages': 'NASA 图片',
      'fourKWallpapers': '4K 壁纸',
      'coverr': 'Coverr',
      'motionBg': 'MotionBG',
      'filter': '筛选',
      'category': '分类',
      'resolution': '分辨率',
      'sortBy': '排序',
      'relevance': '相关度',
      'dateAdded': '添加日期',
      'views': '浏览量',
      'favorites_count': '收藏数',
      'toplist': '排行榜',
      'random': '随机',
      'sfw': '安全',
      'sketchy': '略过',
      'nsfw': '敏感',
      'all': '全部',
      'general': '通用',
      'anime': '动漫',
      'people': '人物',
      'cloudSync': '云同步',
      'aboutDescription': '跨平台壁纸管理应用',
    },
    'ja': {
      'appName': 'Swallpaper',
      'explore': '発見',
      'library': 'ライブラリ',
      'settings': '設定',
      'home': 'ホーム',
      'search': '壁紙を検索...',
      'favorites': 'お気に入り',
      'downloads': 'ダウンロード',
      'noWallpapers': '壁紙が見つかりません',
      'loading': '読み込み中...',
      'error': 'エラーが発生しました',
      'retry': '再試行',
      'apply': '壁紙を適用',
      'download': 'ダウンロード',
      'setWallpaper': '壁紙に設定',
      'about': 'について',
      'theme': 'テーマ',
      'language': '言語',
      'source': 'ソース',
      'apiKey': 'API キー',
      'enterApiKey': 'API キーを入力',
      'save': '保存',
      'cancel': 'キャンセル',
      'confirm': '確認',
      'delete': '削除',
      'wallhaven': 'Wallhaven',
      'unsplash': 'Unsplash',
      'pexels': 'Pexels',
      'pexelsVideos': 'Pexels 動画',
      'nasaApod': 'NASA APOD',
      'nasaImages': 'NASA 画像',
      'fourKWallpapers': '4K 壁紙',
      'coverr': 'Coverr',
      'motionBg': 'MotionBG',
      'filter': 'フィルター',
      'category': 'カテゴリ',
      'resolution': '解像度',
      'sortBy': '並び替え',
      'relevance': '関連度',
      'dateAdded': '追加日',
      'views': '閲覧数',
      'favorites_count': 'お気に入り数',
      'toplist': 'トップリスト',
      'random': 'ランダム',
      'sfw': 'セーフ',
      'sketchy': 'スケッチー',
      'nsfw': 'NSFW',
      'all': 'すべて',
      'general': '一般',
      'anime': 'アニメ',
      'people': '人物',
      'cloudSync': 'クラウド同期',
      'aboutDescription': 'クロスプラットフォーム壁紙マネージャー',
    },
  };

  final Locale locale;

  LocalizationService(this.locale);

  static Future<void> ensureInitialized() async {
    // Initialization logic (e.g., load saved locale)
  }

  String translate(String key) {
    final translations = _localizedStrings[locale.languageCode];
    return translations?[key] ?? _localizedStrings['en']?[key] ?? key;
  }

  static LocalizationService of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService!)!;
  }

  String tr(String key) => translate(key);
}

class _LocalizationServiceDelegate
    extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) =>
      LocalizationService.supportedLocales.contains(locale);

  @override
  Future<LocalizationService> load(Locale locale) async {
    return LocalizationService(locale);
  }

  @override
  bool shouldReload(_LocalizationServiceDelegate old) => false;
}
