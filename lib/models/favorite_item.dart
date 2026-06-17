import 'wallpaper.dart';

class FavoriteItem {
  final String id;
  final Wallpaper wallpaper;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.wallpaper,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'wallpaper': wallpaper.toJson(),
        'addedAt': addedAt.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'] as String,
        wallpaper: Wallpaper.fromJson(json['wallpaper'] as Map<String, dynamic>),
        addedAt: DateTime.parse(json['addedAt'] as String),
      );
}
