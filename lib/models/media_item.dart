class MediaItem {
  final String id;
  final String source;
  final String title;
  final String url;
  final String thumbnailUrl;
  final String type; // 'video' or 'image'
  final int? duration;
  final int width;
  final int height;
  final int fileSize;
  final String? author;
  final String? authorUrl;
  final String? pageUrl;
  final DateTime createdAt;

  MediaItem({
    required this.id,
    required this.source,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.type,
    this.duration,
    this.width = 0,
    this.height = 0,
    this.fileSize = 0,
    this.author,
    this.authorUrl,
    this.pageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get resolution => '${width}x$height';

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'title': title,
        'url': url,
        'thumbnailUrl': thumbnailUrl,
        'type': type,
        'duration': duration,
        'width': width,
        'height': height,
        'fileSize': fileSize,
        'author': author,
        'authorUrl': authorUrl,
        'pageUrl': pageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
        id: json['id'] as String,
        source: json['source'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        type: json['type'] as String,
        duration: json['duration'] as int?,
        width: json['width'] as int? ?? 0,
        height: json['height'] as int? ?? 0,
        fileSize: json['fileSize'] as int? ?? 0,
        author: json['author'] as String?,
        authorUrl: json['authorUrl'] as String?,
        pageUrl: json['pageUrl'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}
