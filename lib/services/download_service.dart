import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/download_task.dart';

class DownloadService extends ChangeNotifier {
  final List<DownloadTask> _tasks = [];
  final Map<String, http.StreamedResponse> _activeDownloads = {};

  List<DownloadTask> get tasks => List.unmodifiable(_tasks);
  List<DownloadTask> get activeTasks =>
      _tasks.where((t) => t.isActive).toList();

  Future<void> downloadFile({
    required String id,
    required String url,
    required String fileName,
    required String source,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final filePath = '${downloadDir.path}/$fileName';

    final task = DownloadTask(
      id: id,
      url: url,
      fileName: fileName,
      filePath: filePath,
      source: source,
    );

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

          final index = _tasks.indexWhere((t) => t.id == id);
          if (index != -1) {
            _tasks[index] = DownloadTask(
              id: task.id,
              url: task.url,
              fileName: task.fileName,
              filePath: task.filePath,
              source: task.source,
              totalBytes: total,
              receivedBytes: received,
              status: DownloadStatus.downloading,
              createdAt: task.createdAt,
            );
            notifyListeners();
          }
        }

        await sink.close();

        final index = _tasks.indexWhere((t) => t.id == id);
        if (index != -1) {
          _tasks[index] = DownloadTask(
            id: task.id,
            url: task.url,
            fileName: task.fileName,
            filePath: task.filePath,
            source: task.source,
            totalBytes: total,
            receivedBytes: total,
            status: DownloadStatus.completed,
            createdAt: task.createdAt,
            completedAt: DateTime.now(),
          );
          notifyListeners();
        }
      } else {
        throw Exception('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = DownloadTask(
          id: task.id,
          url: task.url,
          fileName: task.fileName,
          filePath: task.filePath,
          source: task.source,
          status: DownloadStatus.failed,
          errorMessage: e.toString(),
          createdAt: task.createdAt,
        );
        notifyListeners();
      }
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((t) => t.status == DownloadStatus.completed);
    notifyListeners();
  }
}
