/// TransactPay HTTP client for API interactions.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/logger.dart';
import '../../core/constants.dart';
import 'models/transactpay_models.dart';

/// TransactPay API client with encryption support.
class TransactPayClient {
  final TransactPayConfig _config;
  final http.Client _httpClient;

  /// Base URLs for TransactPay APIs.
  static const String _testBaseUrl = 'https://api-test.transactpay.ai';
  static const String _liveBaseUrl = 'https://api.transactpay.ai';

  TransactPayClient(this._config, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Get base URL based on environment.
  String get _baseUrl => _config.baseUrl ?? 
      (_config.isTestMode ? _testBaseUrl : _liveBaseUrl);

  /// Initialize payment order.
  Future<TransactPayResponse> initializePayment(TransactPayRequest request) async {
    try {
      SDKLogger.info('Initializing TransactPay payment for amount: ${request.order.amount}');
      
      final payload = _encryptPayload(request.toJson());
      
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/api/v1/payment/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_config.apiKey}',
          'X-Secret-Key': _config.secretKey,
          'User-Agent': SDKVersion.userAgent,
        },
        body: jsonEncode({
          'payload': payload,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      SDKLogger.logResponse('POST', '$_baseUrl/api/v1/payment/initialize', response.statusCode);

      if (response.statusCode != 200) {
        throw TransactPayException(
          'Failed to initialize payment: ${response.body}',
          code: 'PAYMENT_INIT_FAILED',
        );
      }

      final responseData = jsonDecode(response.body);
      return _parsePaymentResponse(responseData);
    } catch (e) {
      SDKLogger.error('Failed to initialize TransactPay payment', e);
      if (e is TransactPayException) rethrow;
      throw TransactPayException(
        'Payment initialization failed: ${e.toString()}',
        code: 'PAYMENT_ERROR',
      );
    }
  }

  /// Verify payment status.
  Future<TransactPayResponse> verifyPayment(String reference) async {
    try {
      SDKLogger.info('Verifying TransactPay payment: $reference');
      
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/api/v1/payment/verify/$reference'),
        headers: {
          'Authorization': 'Bearer ${_config.apiKey}',
          'X-Secret-Key': _config.secretKey,
          'User-Agent': SDKVersion.userAgent,
        },
      );

      if (response.statusCode != 200) {
        throw TransactPayException(
          'Failed to verify payment: ${response.body}',
          code: 'PAYMENT_VERIFY_FAILED',
        );
      }

      final responseData = jsonDecode(response.body);
      return _parsePaymentResponse(responseData);
    } catch (e) {
      SDKLogger.error('Failed to verify TransactPay payment', e);
      if (e is TransactPayException) rethrow;
      throw TransactPayException(
        'Payment verification failed: ${e.toString()}',
        code: 'VERIFY_ERROR',
      );
    }
  }

  /// Encrypt payload using RSA encryption key.
  String _encryptPayload(Map<String, dynamic> payload) {
    try {
      // In a real implementation, this would use RSA encryption
      // with the provided encryption key. For now, we'll base64 encode
      // the JSON payload as a placeholder.
      final jsonString = jsonEncode(payload);
      final bytes = utf8.encode(jsonString);
      return base64Encode(bytes);
    } catch (e) {
      throw TransactPayException(
        'Failed to encrypt payload: ${e.toString()}',
        code: 'ENCRYPTION_ERROR',
      );
    }
  }

  /// Parse payment response from API.
  TransactPayResponse _parsePaymentResponse(Map<String, dynamic> data) {
    return TransactPayResponse(
      reference: data['reference'] ?? '',
      status: _parseStatus(data['status']),
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] ?? 'NGN',
      message: data['message'],
      timestamp: data['timestamp'] != null 
          ? DateTime.parse(data['timestamp']) 
          : DateTime.now(),
    );
  }

  /// Parse payment status from string.
  TransactPayStatus _parseStatus(String? status) {
    if (status == null) return TransactPayStatus.pending;
    
    switch (status.toLowerCase()) {
      case 'successful':
      case 'success':
        return TransactPayStatus.successful;
      case 'failed':
      case 'failure':
        return TransactPayStatus.failed;
      case 'cancelled':
      case 'canceled':
        return TransactPayStatus.cancelled;
      case 'processing':
        return TransactPayStatus.processing;
      default:
        return TransactPayStatus.pending;
    }
  }

  /// Dispose resources.
  void dispose() {
    _httpClient.close();
  }
}