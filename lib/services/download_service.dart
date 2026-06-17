import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class DownloadService extends ChangeNotifier {
  List<DownloadTask> _tasks = [];

  List<DownloadTask> get tasks => List.unmodifiable(_tasks);
  List<DownloadTask> get activeTasks => _tasks.where((t) => t.isActive).toList();
  List<DownloadTask> get completedTasks => _tasks.where((t) => t.status == DownloadStatus.completed).toList();

  String? _downloadPath;
  String get downloadPath => _downloadPath ?? '';

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _downloadPath = '${dir.path}/Swallpaper/downloads';
    final d = Directory(_downloadPath!);
    if (!await d.exists()) await d.create(recursive: true);
  }

  Future<void> download(String url, String fileName, String source) async {
    final id = '${DateTime.now().millisecondsSinceEpoch}';
    final filePath = '$_downloadPath/$fileName';

    final task = DownloadTask(id: id, url: url, fileName: fileName, filePath: filePath, source: source);
    _tasks.add(task);
    notifyListeners();

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final file = File(filePath);
        final sink = file.openWrite();
        int received = 0;
        final total = response.contentLength ?? 0;

        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;
          _updateTask(id, receivedBytes: received, totalBytes: total, status: DownloadStatus.downloading);
        }
        await sink.close();
        _updateTask(id, receivedBytes: total, totalBytes: total, status: DownloadStatus.completed, completedAt: DateTime.now());
      } else {
        _updateTask(id, status: DownloadStatus.failed, errorMessage: 'HTTP ${response.statusCode}');
      }
    } catch (e) {
      _updateTask(id, status: DownloadStatus.failed, errorMessage: e.toString());
    }
  }

  void _updateTask(String id, {int? receivedBytes, int? totalBytes, DownloadStatus? status, String? errorMessage, DateTime? completedAt}) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final t = _tasks[idx];
    _tasks[idx] = DownloadTask(
      id: t.id, url: t.url, fileName: t.fileName, filePath: t.filePath,
      source: t.source, totalBytes: totalBytes ?? t.totalBytes,
      receivedBytes: receivedBytes ?? t.receivedBytes,
      status: status ?? t.status, errorMessage: errorMessage ?? t.errorMessage,
      createdAt: t.createdAt, completedAt: completedAt ?? t.completedAt,
    );
    notifyListeners();
  }

  void remove(String id) { _tasks.removeWhere((t) => t.id == id); notifyListeners(); }
  void clearCompleted() { _tasks.removeWhere((t) => t.status == DownloadStatus.completed); notifyListeners(); }
  void retry(DownloadTask task) => download(task.url, task.fileName, task.source);
}
