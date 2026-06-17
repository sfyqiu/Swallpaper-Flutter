class Wallpaper {
  final String id;
  final String source;
  final String title;
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
  final DateTime createdAt;

  Wallpaper({
    required this.id,
    required this.source,
    required this.title,
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
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get resolution => '${width}x$height';

  double get aspectRatio => width > 0 && height > 0 ? width / height : 16 / 9;

  bool get isPortrait => height > width;

  bool get isLandscape => width >= height;

  bool get isVideo => url.endsWith('.mp4') || url.endsWith('.webm');

  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'title': title,
        'url': url,
        'thumbnailUrl': thumbnailUrl,
        'originalUrl': originalUrl,
        'tags': tags,
        'category': category,
        'purity': purity,
        'width': width,
        'height': height,
        'fileSize': fileSize,
        'author': author,
        'authorUrl': authorUrl,
        'pageUrl': pageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
        id: json['id'] as String,
        source: json['source'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        originalUrl: json['originalUrl'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        category: json['category'] as String? ?? 'general',
        purity: json['purity'] as String? ?? 'sfw',
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

  Wallpaper copyWith({
    String? id,
    String? source,
    String? title,
    String? url,
    String? thumbnailUrl,
    String? originalUrl,
    List<String>? tags,
    String? category,
    String? purity,
    int? width,
    int? height,
    int? fileSize,
    String? author,
    String? authorUrl,
    String? pageUrl,
  }) =>
      Wallpaper(
        id: id ?? this.id,
        source: source ?? this.source,
        title: title ?? this.title,
        url: url ?? this.url,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        originalUrl: originalUrl ?? this.originalUrl,
        tags: tags ?? this.tags,
        category: category ?? this.category,
        purity: purity ?? this.purity,
        width: width ?? this.width,
        height: height ?? this.height,
        fileSize: fileSize ?? this.fileSize,
        author: author ?? this.author,
        authorUrl: authorUrl ?? this.authorUrl,
        pageUrl: pageUrl ?? this.pageUrl,
        createdAt: createdAt,
      );
}
