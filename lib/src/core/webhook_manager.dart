import 'dart:convert';
import 'package:crypto/crypto.dart';

class WebhookEvent {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String signature;

  WebhookEvent({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    required this.signature,
  });

  factory WebhookEvent.fromJson(Map<String, dynamic> json) {
    return WebhookEvent(
      id: json['id'] ?? '',
      type: json['event'] ?? json['type'] ?? '',
      data: json['data'] ?? {},
      timestamp: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      signature: json['signature'] ?? '',
    );
  }
}

typedef WebhookHandler = Future<void> Function(WebhookEvent event);

class WebhookManager {
  final Map<String, List<WebhookHandler>> _handlers = {};
  final String _secretKey;

  WebhookManager(this._secretKey);

  void on(String eventType, WebhookHandler handler) {
    _handlers.putIfAbsent(eventType, () => []).add(handler);
  }

  void off(String eventType, [WebhookHandler? handler]) {
    if (handler == null) {
      _handlers.remove(eventType);
    } else {
      _handlers[eventType]?.remove(handler);
    }
  }

  bool verifySignature(String payload, String signature, {String? customSecret}) {
    final secret = customSecret ?? _secretKey;
    final expectedSignature = _generateSignature(payload, secret);
    return signature == expectedSignature;
  }

  String _generateSignature(String payload, String secret) {
    final key = utf8.encode(secret);
    final bytes = utf8.encode(payload);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return 'sha256=${digest.toString()}';
  }

  Future<bool> processWebhook(String payload, String signature) async {
    if (!verifySignature(payload, signature)) {
      return false;
    }

    try {
      final json = jsonDecode(payload);
      final event = WebhookEvent.fromJson(json);
      
      final handlers = _handlers[event.type] ?? [];
      for (final handler in handlers) {
        await handler(event);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}