class Wallpaper {
  final String id;
  final String source;
  String title;
  final String url;
  final String thumbnailUrl;
  final String? originalUrl;
  final List<String> tags;
  final String category;
  final String purity;
  final int width;
  final int height;
  final int fileSize;
  final String? author;
  final String? authorUrl;
  final String? pageUrl;
  final String? resolution;
  final DateTime createdAt;

  Wallpaper({
    required this.id,
    required this.source,
    this.title = '',
    required this.url,
    required this.thumbnailUrl,
    this.originalUrl,
    this.tags = const [],
    this.category = 'general',
    this.purity = 'sfw',
    this.width = 0,
    this.height = 0,
    this.fileSize = 0,
    this.author,
    this.authorUrl,
    this.pageUrl,
    this.resolution,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get res => resolution ?? (width > 0 && height > 0 ? '${width}x$height' : 'Unknown');
  double get aspectRatio => width > 0 && height > 0 ? width / height : 16 / 9;
  bool get isPortrait => height > width;
  bool get isLandscape => width >= height;
  bool get isVideo => url.endsWith('.mp4') || url.endsWith('.webm') || url.endsWith('.mov');

  Map<String, dynamic> toJson() => {
        'id': id, 'source': source, 'title': title, 'url': url,
        'thumbnailUrl': thumbnailUrl, 'originalUrl': originalUrl,
        'tags': tags, 'category': category, 'purity': purity,
        'width': width, 'height': height, 'fileSize': fileSize,
        'author': author, 'authorUrl': authorUrl, 'pageUrl': pageUrl,
        'resolution': resolution, 'createdAt': createdAt.toIso8601String(),
      };

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
        id: json['id'] as String, source: json['source'] as String,
        title: json['title'] as String? ?? '',
        url: json['url'] as String, thumbnailUrl: json['thumbnailUrl'] as String,
        originalUrl: json['originalUrl'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        category: json['category'] as String? ?? 'general',
        purity: json['purity'] as String? ?? 'sfw',
        width: json['width'] as int? ?? 0, height: json['height'] as int? ?? 0,
        fileSize: json['fileSize'] as int? ?? 0,
        author: json['author'] as String?, authorUrl: json['authorUrl'] as String?,
        pageUrl: json['pageUrl'] as String?, resolution: json['resolution'] as String?,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      );

  Wallpaper copyWith({String? title, String? purity}) => Wallpaper(
        id: id, source: source, title: title ?? this.title,
        url: url, thumbnailUrl: thumbnailUrl, originalUrl: originalUrl,
        tags: tags, category: category, purity: purity ?? this.purity,
        width: width, height: height, fileSize: fileSize,
        author: author, authorUrl: authorUrl, pageUrl: pageUrl,
        resolution: resolution, createdAt: createdAt,
      );
}

class MediaItem {
  final String id;
  final String source;
  final String title;
  final String url;
  final String thumbnailUrl;
  final String? previewVideoUrl;
  final String type;
  final int? duration;
  final int width;
  final int height;
  final int fileSize;
  final String? author;
  final String? authorUrl;
  final String? pageUrl;
  final DateTime createdAt;

  MediaItem({
    required this.id, required this.source, required this.title,
    required this.url, required this.thumbnailUrl, this.previewVideoUrl,
    this.type = 'video', this.duration, this.width = 0, this.height = 0,
    this.fileSize = 0, this.author, this.authorUrl, this.pageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';

  Map<String, dynamic> toJson() => {
        'id': id, 'source': source, 'title': title, 'url': url,
        'thumbnailUrl': thumbnailUrl, 'previewVideoUrl': previewVideoUrl,
        'type': type, 'duration': duration, 'width': width, 'height': height,
        'fileSize': fileSize, 'author': author, 'authorUrl': authorUrl,
        'pageUrl': pageUrl, 'createdAt': createdAt.toIso8601String(),
      };

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
        id: json['id'] as String, source: json['source'] as String,
        title: json['title'] as String, url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        previewVideoUrl: json['previewVideoUrl'] as String?,
        type: json['type'] as String? ?? 'video',
        duration: json['duration'] as int?,
        width: json['width'] as int? ?? 0, height: json['height'] as int? ?? 0,
        fileSize: json['fileSize'] as int? ?? 0,
        author: json['author'] as String?, authorUrl: json['authorUrl'] as String?,
        pageUrl: json['pageUrl'] as String?,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      );
}

class FavoriteItem {
  final String id;
  final dynamic item; // Wallpaper or MediaItem
  final String type; // 'wallpaper' or 'media'
  final DateTime addedAt;

  FavoriteItem({required this.id, required this.item, required this.type, DateTime? addedAt})
      : addedAt = addedAt ?? DateTime.now();
}

enum DownloadStatus { pending, downloading, completed, failed, paused }

class DownloadTask {
  final String id;
  final String url;
  final String fileName;
  final String filePath;
  final String source;
  final int totalBytes;
  final int receivedBytes;
  final DownloadStatus status;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? completedAt;

  DownloadTask({
    required this.id, required this.url, required this.fileName,
    required this.filePath, required this.source,
    this.totalBytes = 0, this.receivedBytes = 0,
    this.status = DownloadStatus.pending, this.errorMessage,
    DateTime? createdAt, this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get progress => totalBytes > 0 ? receivedBytes / totalBytes : 0.0;
  bool get isActive => status == DownloadStatus.downloading || status == DownloadStatus.pending;
}
