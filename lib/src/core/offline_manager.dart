import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QueuedRequest {
  final String id;
  final String method;
  final String url;
  final Map<String, dynamic>? data;
  final Map<String, String>? headers;
  final DateTime timestamp;
  final int retryCount;

  QueuedRequest({
    required this.id,
    required this.method,
    required this.url,
    this.data,
    this.headers,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'method': method,
    'url': url,
    'data': data,
    'headers': headers,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };

  factory QueuedRequest.fromJson(Map<String, dynamic> json) {
    return QueuedRequest(
      id: json['id'],
      method: json['method'],
      url: json['url'],
      data: json['data'],
      headers: Map<String, String>.from(json['headers'] ?? {}),
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
    );
  }

  QueuedRequest copyWith({int? retryCount}) {
    return QueuedRequest(
      id: id,
      method: method,
      url: url,
      data: data,
      headers: headers,
      timestamp: timestamp,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

class OfflineManager {
  static const String _queueFileName = 'request_queue.json';
  static const int _maxRetries = 3;
  
  List<QueuedRequest> _queue = [];
  bool _isProcessing = false;

  Future<void> initialize() async {
    await _loadQueue();
  }

  Future<void> queueRequest(QueuedRequest request) async {
    _queue.add(request);
    await _saveQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;
    
    _isProcessing = true;
    final failedRequests = <QueuedRequest>[];

    for (final request in List.from(_queue)) {
      try {
        final success = await _executeRequest(request);
        if (success) {
          _queue.remove(request);
        } else {
          if (request.retryCount < _maxRetries) {
            failedRequests.add(request.copyWith(retryCount: request.retryCount + 1));
          }
          _queue.remove(request);
        }
      } catch (e) {
        if (request.retryCount < _maxRetries) {
          failedRequests.add(request.copyWith(retryCount: request.retryCount + 1));
        }
        _queue.remove(request);
      }
    }

    _queue.addAll(failedRequests);
    await _saveQueue();
    _isProcessing = false;
  }

  Future<bool> _executeRequest(QueuedRequest request) async {
    // This would integrate with your HTTP client
    // Return true if successful, false otherwise
    return true; // Placeholder
  }

  Future<void> _loadQueue() async {
    try {
      final file = await _getQueueFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        _queue = jsonList.map((json) => QueuedRequest.fromJson(json)).toList();
      }
    } catch (e) {
      _queue = [];
    }
  }

  Future<void> _saveQueue() async {
    try {
      final file = await _getQueueFile();
      final jsonList = _queue.map((request) => request.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      // Handle error
    }
  }

  Future<File> _getQueueFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_queueFileName');
  }

  void clearQueue() {
    _queue.clear();
    _saveQueue();
  }

  int get queueLength => _queue.length;
}