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
    required this.id,
    required this.url,
    required this.fileName,
    required this.filePath,
    required this.source,
    this.totalBytes = 0,
    this.receivedBytes = 0,
    this.status = DownloadStatus.pending,
    this.errorMessage,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get progress => totalBytes > 0 ? receivedBytes / totalBytes : 0.0;

  bool get isActive =>
      status == DownloadStatus.downloading || status == DownloadStatus.pending;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'fileName': fileName,
        'filePath': filePath,
        'source': source,
        'totalBytes': totalBytes,
        'receivedBytes': receivedBytes,
        'status': status.name,
        'errorMessage': errorMessage,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory DownloadTask.fromJson(Map<String, dynamic> json) => DownloadTask(
        id: json['id'] as String,
        url: json['url'] as String,
        fileName: json['fileName'] as String,
        filePath: json['filePath'] as String,
        source: json['source'] as String,
        totalBytes: json['totalBytes'] as int? ?? 0,
        receivedBytes: json['receivedBytes'] as int? ?? 0,
        status: DownloadStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => DownloadStatus.pending,
        ),
        errorMessage: json['errorMessage'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );
}
